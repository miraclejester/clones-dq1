extends CanvasLayer
class_name BattleUI

signal fight_selected()

signal dialogue_finished()

@export var battle_start_dialogue_data: DialogueEvent
@export var command_dialogue_data: DialogueEvent
@export var attack_dialogue: DialogueEvent
@export var enemy_hurt_dialogue: DialogueEvent

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


func current_dialogue_finished() -> void:
	dialogue_finished.emit()


func update_hud() -> void:
	player_hud.update_from_hero()


func command_selected(idx: int) -> void:
	match idx:
		0:
			fight_selected.emit()
