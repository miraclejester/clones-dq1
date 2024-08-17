extends UIMenu
class_name ShopInterface

@onready var dialogue_window: DialogueWindow = %DialogueWindow
@onready var products_window: CommandWindow = %ProductsWindow

var data: ShopData

func _ready() -> void:
	products_window.visible = false


func start(d: ShopData) -> void:
	data = d
	dialogue_window.clean_window()
	await dialogue_window.start_dialogue([
		DialogueEventParams.fromData(data.initial_dialogue)
	])
	product_showcase_question()


func buy_intention_selected() -> void:
	await dialogue_window.show_newline()
	await dialogue_window.start_dialogue([
		DialogueEventParams.fromData(data.what_buy_dialogue)
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
	dialogue_window.show_newline()
	await dialogue_window.start_dialogue([
		DialogueEventParams.fromData(
			data.item_selected_dialogue,
			{
				PlayParagraphDialogueEvent.ParagraphEventKeys.FORMAT_VARS : [product.item_name]
			}
		)
	])
	await dialogue_window.wait_for_continuation(true)
	if product.buy_price > PlayerManager.hero.gold:
		await dialogue_window.start_dialogue([
			DialogueEventParams.fromData(data.not_enough_money_dialogue)
		])
		await dialogue_window.wait_for_continuation(true)
		buy_again_flow()
	else:
		var cur_equip: EquipmentData = PlayerManager.hero.equipment.get_equip(product.equipment_type)
		if product is EquipmentData:
			if cur_equip != null:
				await dialogue_window.start_dialogue([
					DialogueEventParams.fromData(data.rebuy_equipment_dialogue, {
						PlayParagraphDialogueEvent.ParagraphEventKeys.FORMAT_VARS: [
							cur_equip.item_name,
							cur_equip.sell_price
						]
					})
				])
				await dialogue_window.wait_for_continuation(true)
		await dialogue_window.start_dialogue([
			DialogueEventParams.fromData(data.buy_confirm_dialogue)
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
		DialogueEventParams.fromData(data.item_bought_dialogue)
	])
	if previous_item != null:
		PlayerManager.hero.add_gold(previous_item.sell_price)
	PlayerManager.hero.spend_gold(item.buy_price)
	if item is EquipmentData:
		PlayerManager.hero.equipment.equip(item)
	else:
		PlayerManager.hero.inventory.add_item(item)
		if previous_item != null:
			PlayerManager.hero.inventory.remove_item(previous_item)
	await dialogue_window.wait_for_continuation(true)
	buy_again_flow()


func on_buy_cancelled() -> void:
	await dialogue_window.show_newline()
	await dialogue_window.start_dialogue([
		DialogueEventParams.fromData(data.buy_cancelled_dialogue)
	])
	await dialogue_window.wait_for_continuation(true)
	buy_again_flow()


func product_showcase_question() -> void:
	dialogue_window.prompt_yes_no(buy_intention_selected, exit_shop)


func buy_again_flow() -> void:
	await dialogue_window.start_dialogue([
		DialogueEventParams.fromData(data.buy_again_dialogue)
	])
	product_showcase_question()


func exit_shop():
	await dialogue_window.show_newline()
	await dialogue_window.start_dialogue([
		DialogueEventParams.fromData(data.goodbye_dialogue)
	])
	await dialogue_window.wait_for_continuation(false)
	finish()


func finish() -> void:
	cancelled.emit()
