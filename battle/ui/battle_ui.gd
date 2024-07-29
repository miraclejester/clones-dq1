extends CanvasLayer
class_name BattleUI

signal fight_selected()
signal run_selected()

signal dialogue_finished()

@export var low_health_color: Color

@onready var player_hud: PlayerHUD = $PlayerHud
@onready var command_window: CommandWindow = $CommandWindow
@onready var dialogue_window: DialogueWindow = $DialogueWindow


func _ready() -> void:
	command_window.selected.connect(command_selected)
	dialogue_window.current_dialogue_finished.connect(current_dialogue_finished)


func initialize() -> void:
	player_hud.visible = false
	command_window.visible = false
	dialogue_window.visible = false


func set_hero_data(hero: BattleUnit) -> void:
	player_hud.set_hero(hero)


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


func show_battle_paragraph(id: GeneralDialogueProvider.DialogueID, format_vars: Array = [], continuing: bool = false) -> void:
	await dialogue_window.show_paragraph(id, format_vars, continuing).current_dialogue_finished
	await get_tree().create_timer(0.2).timeout

func show_newline(continuing: bool) -> void:
	await show_battle_paragraph(
		GeneralDialogueProvider.DialogueID.Newline, [], continuing
	)


func current_dialogue_finished() -> void:
	dialogue_finished.emit()


func update_hud() -> void:
	player_hud.update_from_hero()


func set_to_low_health() -> void:
	player_hud.modulate = low_health_color
	command_window.modulate = low_health_color
	dialogue_window.modulate = low_health_color


func set_to_normal_health() -> void:
	player_hud.modulate = Color.WHITE
	command_window.modulate = Color.WHITE
	dialogue_window.modulate = Color.WHITE


func determine_ui_colors(hp: int, max_hp: int) -> void:
	if hp <= floor(max_hp / 5.0):
		set_to_low_health()
	else:
		set_to_normal_health()


func command_selected(idx: int) -> void:
	match idx:
		0:
			fight_selected.emit()
		2:
			run_selected.emit()
