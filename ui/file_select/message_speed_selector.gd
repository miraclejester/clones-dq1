extends UIMenu
class_name MessageSpeedSelector

signal speed_selected(idx: int)

@onready var command_window: CommandWindow = %CommandWindow


func _ready() -> void:
	command_window.cancelled.connect(func(): cancelled.emit())
	command_window.initialize_commands([
		CommandData.new("FAST", select_speed.bind(0)),
		CommandData.new("NORMAL", select_speed.bind(1)),
		CommandData.new("SLOW", select_speed.bind(2))
	], 1)


func select_speed(idx: int) -> void:
	speed_selected.emit(idx)


func activate() -> void:
	command_window.activate()


func deactivate() -> void:
	command_window.deactivate()
