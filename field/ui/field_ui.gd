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

@onready var visuals_parent: Control = $VisualsParent
@onready var player_hud: PlayerHUD = %PlayerHud
@onready var command_window: CommandWindow = %CommandWindow
@onready var dialogue_window: DialogueWindow = %DialogueWindow

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
	player_hud.set_hero(hero)


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


func play_dialogue(dialogue: DialogueEvent, params: Dictionary = {}) -> void:
	dialogue_window.visible = true
	dialogue_window.clean_window()
	await dialogue_window.start_dialogue([DialogueEventParams.fromData(dialogue, params)])
	await dialogue_window.wait_for_continuation(false)
	dialogue_window.visible = false


func on_command_cancelled() -> void:
	command_cancelled.emit()
