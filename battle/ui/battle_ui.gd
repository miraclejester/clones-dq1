extends CanvasLayer
class_name BattleUI

signal fight_selected()
signal spell_selected()
signal run_selected()

signal spell_data_selected()
signal spell_cancelled()

signal dialogue_finished()

@export var low_health_color: Color

@onready var visuals_parent: Control = $VisualsParent
@onready var player_hud: PlayerHUD = %PlayerHud
@onready var command_window: CommandWindow = %CommandWindow
@onready var dialogue_window: DialogueWindow = %DialogueWindow
@onready var spell_window: SpellWindow = %SpellWindow



func _ready() -> void:
	command_window.selected.connect(command_selected)
	dialogue_window.current_dialogue_finished.connect(current_dialogue_finished)
	spell_window.spell_selected.connect(spell_selected_from_menu)
	spell_window.cancelled.connect(spell_menu_cancelled)
	
	command_window.initialize_commands(["FIGHT", "SPELL", "RUN", "ITEM"], 2)


func initialize() -> void:
	for child in visuals_parent.get_children():
		(child as Control).visible = false


func set_hero_data(hero: BattleUnit) -> void:
	player_hud.set_hero(hero)
	spell_window.set_spells(hero.spells)


func show_dialogue_window() -> void:
	dialogue_window.visible = true


func show_hud() -> void:
	player_hud.visible = true


func show_command_window() -> void:
	command_window.visible = true
	MenuStack.push_stack(command_window, command_window.activate, command_window.deactivate)
	

func hide_command_window() -> void:
	command_window.visible = false
	MenuStack.pop_stack()


func show_spell_window() -> void:
	spell_window.visible = true
	await MenuStack.push_stack(spell_window, spell_window.activate, spell_window.deactivate)


func hide_spell_window() -> void:
	spell_window.visible = false
	await MenuStack.pop_stack()


func show_line(id: GeneralDialogueProvider.DialogueID, format_vars: Array = []) -> void:
	await dialogue_window.show_paragraph(id, format_vars).current_dialogue_finished
	await get_tree().create_timer(0.2).timeout


func show_newline() -> void:
	await show_line(
		GeneralDialogueProvider.DialogueID.Newline
	)


func current_dialogue_finished() -> void:
	dialogue_finished.emit()


func update_hud() -> void:
	player_hud.update_from_hero()


func set_to_low_health() -> void:
	visuals_parent.modulate = low_health_color


func set_to_normal_health() -> void:
	visuals_parent.modulate = Color.WHITE


func determine_ui_colors(hp: int, max_hp: int) -> void:
	if hp <= floor(max_hp / 5.0):
		set_to_low_health()
	else:
		set_to_normal_health()


func command_selected(idx: int) -> void:
	match idx:
		0:
			fight_selected.emit()
		1:
			spell_selected.emit()
		2:
			run_selected.emit()


func spell_selected_from_menu(spell: SpellData) -> void:
	spell_data_selected.emit(spell)


func spell_menu_cancelled() -> void:
	spell_cancelled.emit()
