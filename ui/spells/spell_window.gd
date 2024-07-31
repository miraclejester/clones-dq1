extends Control
class_name SpellWindow

signal spell_selected(data: SpellData)
signal cancelled()

@onready var command_window: CommandWindow = $CommandWindow

var spells: Array[SpellData] = []


func _ready() -> void:
	command_window.selected.connect(command_selected)
	command_window.cancelled.connect(command_cancelled)


func set_spells(s: Array[SpellData]) -> void:
	spells = s
	var spell_names: Array[String] = []
	spell_names.assign(spells.map(func(spell: SpellData): return spell.spell_name))
	command_window.initialize_commands(spell_names, 1)


func command_selected(idx: int) -> void:
	spell_selected.emit(spells[idx])


func command_cancelled() -> void:
	cancelled.emit()


func activate() -> void:
	command_window.activate()


func deactivate() -> void:
	command_window.deactivate()
