extends DialogueEvent
class_name NewlineDialogueEvent

func execute(window: DialogueWindow, _params: Dictionary) -> void:
	window.add_line()
	finish()
