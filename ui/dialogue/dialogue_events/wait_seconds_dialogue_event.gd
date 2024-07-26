extends DialogueEvent
class_name WaitSecondsDialogueEvent

@export var wait_seconds: float = 1.0

func execute(window: DialogueWindow, _params: Dictionary) -> void:
	await window.get_tree().create_timer(wait_seconds).timeout
	finish()
