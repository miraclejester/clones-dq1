extends CanvasLayer
class_name BattleUI

signal fight_selected()
signal spell_selected()
signal run_selected()
signal item_selected()

signal dialogue_finished()

@export var low_health_color: Color

@onready var visuals_parent: Control = $VisualsParent
@onready var player_hud: PlayerHUD = %PlayerHud
@onready var command_window: CommandWindow = %CommandWindow
@onready var dialogue_window: DialogueWindow = %DialogueWindow
@onready var spell_window: SpellWindow = %SpellWindow
@onready var item_window: ItemWindow = %ItemWindow



func _ready() -> void:
	dialogue_window.current_dialogue_finished.connect(current_dialogue_finished)
	
	command_window.initialize_commands(
		[
			CommandData.new("FIGHT", func (): fight_selected.emit()),
			CommandData.new("SPELL", func (): spell_selected.emit()), 
			CommandData.new("RUN", func (): run_selected.emit()),
			CommandData.new("ITEM", func (): item_selected.emit())
		],
		2
	)


func initialize() -> void:
	for child in visuals_parent.get_children():
		(child as Control).visible = false
	dialogue_window.clean_window()


func set_hero_data(hero: BattleUnit) -> void:
	player_hud.set_hero(hero)
	spell_window.set_spells(hero.spells)


func refresh_inventory(hero: HeroUnit) -> void:
	item_window.set_items(hero.inventory.items)


func show_dialogue_window() -> void:
	dialogue_window.visible = true


func show_hud() -> void:
	player_hud.visible = true


func show_command_window(cancel_callback: Callable) -> void:
	command_window.visible = true
	command_window.set_selection(0)
	MenuStack.push_stack(
		command_window,
		command_window.activate,
		command_window.deactivate,
		cancel_callback
	)


func show_spell_window(spell_selected_callback: Callable, cancel_callback: Callable) -> void:
	spell_window.visible = true
	await MenuStack.push_stack(
		spell_window,
		spell_window.activate,
		spell_window.deactivate,
		func ():
			spell_window.spell_selected.disconnect(spell_selected_callback)
			cancel_callback.call()
	)
	spell_window.spell_selected.connect(spell_selected_callback, CONNECT_ONE_SHOT)


func hide_command_window() -> void:
	command_window.visible = false


func hide_spell_window() -> void:
	spell_window.visible = false


func show_item_window(item_selected_callback: Callable, cancel_callback: Callable) -> void:
	item_window.visible = true
	await MenuStack.push_stack(
		item_window,
		item_window.activate,
		item_window.deactivate,
		func ():
			item_window.item_selected.disconnect(item_selected_callback)
			cancel_callback.call()
	)
	item_window.item_selected.connect(item_selected_callback, CONNECT_ONE_SHOT)


func hide_item_window() -> void:
	item_window.visible = false


func wait_for_dialogue_continuation(cont_visible: bool = true) -> void:
	await dialogue_window.wait_for_continuation(cont_visible)


func show_line(id: GeneralDialogueProvider.DialogueID, format_vars: Array = []) -> void:
	await show_line_from_data(GeneralDialogueProvider.get_dialogue(id), format_vars)


func show_line_from_data(data: DialogueEvent, format_vars: Array = []) -> void:
	await dialogue_window.show_paragraph_from_data(data, format_vars)


func play_dialogue(data: DialogueEvent, params: Dictionary = {}) -> void:
	await dialogue_window.start_dialogue([DialogueEventParams.fromData(data, params)])


func show_newline() -> void:
	await show_line(
		GeneralDialogueProvider.DialogueID.Newline
	)


func current_dialogue_finished() -> void:
	dialogue_finished.emit()


func update_player_stat(key: PlayerHUD.HUDStatKey, val: int) -> void:
	player_hud.update_stat(key, val)
