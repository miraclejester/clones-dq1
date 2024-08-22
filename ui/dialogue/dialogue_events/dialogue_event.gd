extends Resource
class_name DialogueEvent

@export var skip_window: bool = false

func execute(window: DialogueWindow, _params: Dictionary) -> void:
	await window.get_tree().process_frame
