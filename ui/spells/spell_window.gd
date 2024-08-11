extends Control
class_name SpellWindow

signal spell_selected(data: SpellData)
signal cancelled()

@onready var command_window: CommandWindow = $CommandWindow

var spells: Array[SpellData] = []


func _ready() -> void:
	command_window.cancelled.connect(command_cancelled)


func set_spells(s: Array[SpellData]) -> void:
	spells = s
	var spell_commands: Array[CommandData] = []
	spell_commands.assign(spells.map(
			func(spell: SpellData): return CommandData.new(spell.spell_name, func (): spell_selected.emit(spell))
		)
	)
	command_window.initialize_commands(spell_commands, 1)


func command_cancelled() -> void:
	cancelled.emit()


func activate() -> void:
	command_window.activate()


func deactivate() -> void:
	command_window.deactivate()
