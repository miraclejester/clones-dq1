extends Resource
class_name DialogueEvent

func execute(window: DialogueWindow, _params: Dictionary) -> void:
	await window.get_tree().process_frame
