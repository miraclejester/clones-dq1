extends DialogueEvent
class_name QuitGameDialogueEvent

func execute(window: DialogueWindow, _params: Dictionary) -> void:
	await window.get_tree().process_frame
	window.get_tree().quit()
