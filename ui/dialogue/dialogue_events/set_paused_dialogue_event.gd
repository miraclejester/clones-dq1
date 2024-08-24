extends DialogueEvent
class_name SetPausedDialogueEvent

@export var pause: bool = true

func execute(window: DialogueWindow, _params: Dictionary) -> void:
	await window.get_tree().process_frame
	window.get_tree().paused = pause
