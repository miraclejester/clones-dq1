extends CanvasLayer
class_name FieldUI

signal talk_selected()
signal spell_selected()
signal status_selected()
signal item_selected()
signal stairs_selected()
signal door_selected()
signal search_selected()
signal take_selected()

signal command_cancelled()
signal full_inventory_flow_finished()

@export var full_inventory_initial_dialogue: DialogueEvent
@export var full_inventory_what_drop: DialogueEvent
@export var full_inventory_dropped_item_dialogue: DialogueEvent
@export var full_inventory_obtained_item_dialogue: DialogueEvent
@export var full_inventory_cannot_drop_dialogue: DialogueEvent
@export var full_inventory_given_up_dialogue: DialogueEvent
@export var full_inventory_herb: DialogueEvent

@onready var visuals_parent: Control = $VisualsParent
@onready var player_hud: PlayerHUD = %PlayerHud
@onready var command_window: CommandWindow = %CommandWindow
@onready var dialogue_window: DialogueWindow = %DialogueWindow
@onready var item_window: ItemWindow = %ItemWindow
@onready var status_window: StatusWindow = %StatusWindow
@onready var shop_interface: ShopInterface = %ShopInterface
@onready var spell_window: SpellWindow = %SpellWindow



var command_select_signals: Array[Signal] = [
	talk_selected, spell_selected,
	status_selected, item_selected,
	stairs_selected, door_selected,
	search_selected, take_selected
]


func _ready() -> void:
	for child in visuals_parent.get_children():
		(child as Control).visible = false
	set_hero(PlayerManager.hero)
	var commands: Array[CommandData] = [
		CommandData.new("TALK", func() : talk_selected.emit()),
		CommandData.new("SPELL", func() : spell_selected.emit()),
		CommandData.new("STATUS", func() : status_selected.emit()),
		CommandData.new("ITEM", func() : item_selected.emit()),
		CommandData.new("STAIRS", func() : stairs_selected.emit()),
		CommandData.new("DOOR", func() : door_selected.emit()),
		CommandData.new("SEARCH", func() : search_selected.emit()),
		CommandData.new("TAKE", func() : take_selected.emit()),
	]
	command_window.initialize_commands(commands, 2)
	
	command_window.cancelled.connect(on_command_cancelled)


func set_hero(hero: HeroUnit) -> void:
	player_hud.set_hero(hero, true)


func show_hud() -> void:
	player_hud.visible = true


func hide_hud() -> void:
	player_hud.visible = false


func show_command_window() -> void:
	command_window.visible = true
	command_window.set_selection(0)
	show_hud()
	await MenuStack.push_stack(command_window, command_window.activate, command_window.deactivate)


func hide_command_window() -> void:
	command_window.visible = false


func show_item_window(item_selected_callback: Callable, on_close: Callable) -> void:
	var selected_callable: Callable = func (item: ItemData):
		MenuStack.pop_stack()
		item_window.visible = false
		item_selected_callback.call(item)
	
	item_window.set_items(PlayerManager.hero.inventory.items)
	item_window.visible = true
	await MenuStack.push_stack(
		item_window,
		item_window.activate,
		item_window.deactivate,
		func ():
			item_window.item_selected.disconnect(selected_callable)
			item_window.visible = false
			await MenuStack.pop_stack()
			on_close.call()
	)
	item_window.item_selected.connect(
		selected_callable,
		CONNECT_ONE_SHOT
	)


func full_inventory_flow(desired_item: ItemData) -> void:
	if desired_item.item_id == 23:
		await dialogue_window.start_dialogue([
			DialogueEventParams.fromData(full_inventory_herb)
		])
		full_inventory_flow_finished.emit()
		return
		
	await dialogue_window.start_dialogue([
		DialogueEventParams.fromData(full_inventory_initial_dialogue, {
			"item_name_provider_item": desired_item
		})
	])
	await dialogue_window.prompt_yes_no(full_inventory_choose_drop.bind(desired_item), full_inventory_give_up.bind(desired_item))


func full_inventory_choose_drop(desired_item: ItemData) -> void:
	await dialogue_window.start_dialogue([
		DialogueEventParams.fromData(full_inventory_what_drop)
	])
	await show_item_window(full_inventory_item_dropped.bind(desired_item), full_inventory_give_up.bind(desired_item))


func full_inventory_item_dropped(dropped_item: ItemData, desired_item: ItemData) -> void:
	if not dropped_item.sellable:
		await dialogue_window.start_dialogue([
			DialogueEventParams.fromData(full_inventory_cannot_drop_dialogue)
		])
		await full_inventory_choose_drop(desired_item)
	else:
		PlayerManager.hero.inventory.remove_item(dropped_item)
		await dialogue_window.start_dialogue([
			DialogueEventParams.fromData(full_inventory_dropped_item_dialogue , {
				"item_name_provider_item": dropped_item
			})
		])
		PlayerManager.hero.inventory.add_item(desired_item)
		await dialogue_window.start_dialogue([
			DialogueEventParams.fromData(full_inventory_obtained_item_dialogue , {
				"item_name_provider_item": desired_item
			})
		])
		full_inventory_flow_finished.emit()


func full_inventory_give_up(desired_item: ItemData) -> void:
	await dialogue_window.start_dialogue([
		DialogueEventParams.fromData(full_inventory_given_up_dialogue , {
			"item_name_provider_item": desired_item
		})
	])
	full_inventory_flow_finished.emit()


func show_spell_window(spell_selected_callback: Callable, on_close: Callable) -> void:
	var selected_callable: Callable = func (spell: SpellData):
		MenuStack.pop_stack()
		spell_window.visible = false
		spell_selected_callback.call(spell)
	
	spell_window.set_spells(PlayerManager.hero.spells)
	spell_window.visible = true
	await MenuStack.push_stack(
		spell_window,
		spell_window.activate,
		spell_window.deactivate,
		func ():
			spell_window.spell_selected.disconnect(selected_callable)
			spell_window.visible = false
			await MenuStack.pop_stack()
			on_close.call()
	)
	spell_window.spell_selected.connect(selected_callable, CONNECT_ONE_SHOT)


func show_status_window(on_cancel: Callable) -> void:
	await MenuStack.push_stack(
		status_window,
		status_window.activate,
		status_window.deactivate,
		on_cancel
	)
	status_window.set_data_from_hero(PlayerManager.hero)
	status_window.visible = true


func hide_status_window() -> void:
	status_window.visible = false


func play_dialogue(dialogue: DialogueEvent, params: Dictionary = {}, clean_window: bool = true) -> void:
	dialogue_window.visible = params.get("make_window_visible", true)
	if clean_window:
		dialogue_window.clean_window()
	await dialogue_window.start_dialogue([DialogueEventParams.fromData(dialogue, params)])
	if params.get("wait_for_continuation", not dialogue.skip_window):
		await dialogue_window.wait_for_continuation(false)
	dialogue_window.visible = false


func on_command_cancelled() -> void:
	command_cancelled.emit()
