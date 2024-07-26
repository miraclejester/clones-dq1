extends Resource
class_name DialogueEvent

signal event_finished

func execute(_window: DialogueWindow, _params: Dictionary) -> void:
	pass


func finish() -> void:
	event_finished.emit()
