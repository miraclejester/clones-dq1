extends UIMenu
class_name ShopInterface

@onready var dialogue_window: DialogueWindow = %DialogueWindow
@onready var products_window: CommandWindow = %ProductsWindow
@onready var buy_or_sell_choice: CommandWindow = %BuyOrSellChoice
@onready var item_window: ItemWindow = %ItemWindow

var data: ShopData

func _ready() -> void:
	products_window.visible = false
	buy_or_sell_choice.visible = false
	item_window.visible = false


func start(d: ShopData) -> void:
	data = d
	dialogue_window.clean_window()
	
	if data.is_single_item_shop:
		await dialogue_window.start_dialogue([
			DialogueEventParams.fromData(data.dialogues.initial_dialogue, {
				PlayParagraphDialogueEvent.ParagraphEventKeys.FORMAT_VARS: [data.single_item_price]
			})
		])
		dialogue_window.prompt_yes_no(buy_single_item_selected, exit_shop)
		return
	
	await dialogue_window.start_dialogue([
		DialogueEventParams.fromData(data.dialogues.initial_dialogue)
	])
	if data.can_sell:
		buy_sell_question()
	else:
		product_showcase_question()


func buy_single_item_selected() -> void:
	if not PlayerManager.hero.inventory.item_fits_inventory(data.single_item):
		await dialogue_window.show_newline()
		await dialogue_window.start_dialogue([
			DialogueEventParams.fromData(data.dialogues.cannot_sell_more_dialogue)
		])
		exit_shop()
	elif PlayerManager.hero.gold >= data.single_item_price:
		PlayerManager.hero.spend_gold(data.single_item_price)
		PlayerManager.hero.inventory.add_item(data.single_item)
		await dialogue_window.show_newline()
		await dialogue_window.start_dialogue([
			DialogueEventParams.fromData(data.dialogues.item_bought_dialogue)
		])
		dialogue_window.prompt_yes_no(buy_single_item_selected, exit_shop)
	else:
		await dialogue_window.show_newline()
		await dialogue_window.start_dialogue([
			DialogueEventParams.fromData(data.dialogues.not_enough_money_dialogue)
		])
		exit_shop()


func buy_intention_selected() -> void:
	await dialogue_window.show_newline()
	await dialogue_window.start_dialogue([
		DialogueEventParams.fromData(data.dialogues.what_buy_dialogue)
	])
	show_products()


func show_products() -> void:
	var commands: Array[CommandData] = []
	for item in data.items:
		commands.append(CommandData.new(
			item.item_name,
			product_selected.bind(item),
			item.buy_price,
			true
		))
	products_window.initialize_commands(commands, 1)
	products_window.visible = true
	MenuStack.push_stack(
		products_window,
		products_window.activate,
		products_window.deactivate,
		func ():
			await MenuStack.pop_stack()
			products_window.visible = false
			exit_shop()
	)


func product_selected(product: ItemData) -> void:
	await MenuStack.pop_stack()
	products_window.visible = false
	if data.can_sell:
		await purchase_flow_for_selling(product)
	else:
		await purchase_flow_for_non_selling(product)


func purchase_flow_for_selling(product: ItemData) -> void:
	if product.buy_price > PlayerManager.hero.gold:
		await dialogue_window.show_newline()
		await dialogue_window.start_dialogue([
			DialogueEventParams.fromData(data.dialogues.not_enough_money_dialogue)
		])
		await dialogue_window.wait_for_continuation(true)
		buy_again_flow()
	elif not PlayerManager.hero.inventory.item_fits_inventory(product):
		await dialogue_window.show_newline()
		await dialogue_window.start_dialogue([
			DialogueEventParams.fromData(data.dialogues.cannot_carry_more)
		])
		await dialogue_window.wait_for_continuation(true)
		buy_again_flow()
	else:
		await on_item_bought(product)


func purchase_flow_for_non_selling(product: ItemData) -> void:
	dialogue_window.show_newline()
	await dialogue_window.start_dialogue([
		DialogueEventParams.fromData(
			data.dialogues.item_selected_dialogue,
			{
				PlayParagraphDialogueEvent.ParagraphEventKeys.FORMAT_VARS : [product.item_name]
			}
		)
	])
	await dialogue_window.wait_for_continuation(true)
	if product.buy_price > PlayerManager.hero.gold:
		await dialogue_window.start_dialogue([
			DialogueEventParams.fromData(data.dialogues.not_enough_money_dialogue)
		])
		await dialogue_window.wait_for_continuation(true)
		buy_again_flow()
	else:
		var cur_equip: EquipmentData = PlayerManager.hero.equipment.get_equip(product.equipment_type)
		if product is EquipmentData:
			if cur_equip != null:
				if not cur_equip.sellable:
					await dialogue_window.start_dialogue([
						DialogueEventParams.fromData(data.dialogues.cannot_buy_dialogue)
					])
					buy_again_flow()
					return
				await dialogue_window.start_dialogue([
					DialogueEventParams.fromData(data.dialogues.rebuy_equipment_dialogue, {
						PlayParagraphDialogueEvent.ParagraphEventKeys.FORMAT_VARS: [
							cur_equip.item_name,
							cur_equip.sell_price
						]
					})
				])
				await dialogue_window.wait_for_continuation(true)
		await dialogue_window.start_dialogue([
			DialogueEventParams.fromData(data.dialogues.buy_confirm_dialogue)
		])
		dialogue_window.prompt_yes_no(
			on_item_bought.bind(product, cur_equip),
			on_buy_cancelled
		)


func activate() -> void:
	visible = true


func on_item_bought(item: ItemData, previous_item: ItemData = null) -> void:
	await dialogue_window.show_newline()
	await dialogue_window.start_dialogue([
		DialogueEventParams.fromData(data.dialogues.item_bought_dialogue, {
			PlayParagraphDialogueEvent.ParagraphEventKeys.FORMAT_VARS : [item.item_name]
		})
	])
	if previous_item != null:
		PlayerManager.hero.add_gold(previous_item.sell_price)
	PlayerManager.hero.spend_gold(item.buy_price)
	if item is EquipmentData:
		PlayerManager.hero.equipment.equip(item)
	else:
		PlayerManager.hero.inventory.add_item(item)
	await dialogue_window.wait_for_continuation(true)
	buy_again_flow()


func on_buy_cancelled() -> void:
	await dialogue_window.show_newline()
	await dialogue_window.start_dialogue([
		DialogueEventParams.fromData(data.dialogues.buy_cancelled_dialogue)
	])
	await dialogue_window.wait_for_continuation(true)
	buy_again_flow()


func product_showcase_question() -> void:
	dialogue_window.prompt_yes_no(buy_intention_selected, exit_shop)


func buy_sell_question() -> void:
	var cancel: Callable = func ():
		buy_or_sell_choice.visible = false
		await MenuStack.pop_stack()
	buy_or_sell_choice.initialize_commands([
		CommandData.new("BUY", func ():
			cancel.call()
			buy_intention_selected()
			),
		CommandData.new("SELL", func ():
			cancel.call()
			sell_selected()
			)
	], 1)
	await MenuStack.push_stack(
		buy_or_sell_choice,
		buy_or_sell_choice.activate,
		buy_or_sell_choice.deactivate,
		func ():
			cancel.call()
			exit_shop()
	)
	buy_or_sell_choice.visible = true


func sell_selected() -> void:
	await dialogue_window.show_newline()
	if PlayerManager.hero.inventory.stack_count() == 0:
		await dialogue_window.start_dialogue([
			DialogueEventParams.fromData(data.dialogues.no_sellable_items_dialogue)
		])
		exit_shop()
		return
	if PlayerManager.hero.is_cursed:
		await dialogue_window.start_dialogue([DialogueEventParams.fromData(data.dialogues.cursed_item_dialogue)])
		exit_shop()
		return
	await dialogue_window.start_dialogue([
		DialogueEventParams.fromData(data.dialogues.what_sell_dialogue)
	])
	item_window.set_items(PlayerManager.hero.inventory.items)
	await MenuStack.push_stack(
		item_window,
		item_window.activate,
		item_window.deactivate,
		func ():
			await MenuStack.pop_stack()
			item_window.visible = false
			item_window.item_selected.disconnect(item_to_sell_selected)
			exit_shop()
	)
	item_window.visible = true
	item_window.item_selected.connect(item_to_sell_selected, CONNECT_ONE_SHOT)


func item_to_sell_selected(item: ItemData) -> void:
	await MenuStack.pop_stack()
	item_window.visible = false
	await dialogue_window.show_newline()
	
	if not item.sellable:
		await dialogue_window.start_dialogue([
			DialogueEventParams.fromData(data.dialogues.cannot_buy_dialogue)
		])
		await sell_again_flow()
		return
	
	await dialogue_window.start_dialogue([
		DialogueEventParams.fromData(data.dialogues.sell_confirm_dialogue, {
			PlayParagraphDialogueEvent.ParagraphEventKeys.FORMAT_VARS : [item.item_name, item.sell_price]
		})
	])
	dialogue_window.prompt_yes_no(
		func ():
			PlayerManager.hero.inventory.remove_item(item)
			PlayerManager.hero.add_gold(item.sell_price)
			await sell_again_flow(),
		sell_again_flow
	)


func sell_again_flow() -> void:
	await dialogue_window.show_newline()
	await dialogue_window.start_dialogue([
		DialogueEventParams.fromData(data.dialogues.sell_again_dialogue)
	])
	dialogue_window.prompt_yes_no(sell_selected, exit_shop)


func buy_again_flow() -> void:
	await dialogue_window.start_dialogue([
		DialogueEventParams.fromData(data.dialogues.buy_again_dialogue)
	])
	product_showcase_question()


func exit_shop():
	await dialogue_window.show_newline()
	await dialogue_window.start_dialogue([
		DialogueEventParams.fromData(data.dialogues.goodbye_dialogue)
	])
	await dialogue_window.wait_for_continuation(false)
	finish()


func finish() -> void:
	cancelled.emit()
