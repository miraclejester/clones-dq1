extends DialogueEvent
class_name FadeOutDialogueEvent

func execute(_window: DialogueWindow, _params: Dictionary) -> void:
	await GlobalVisuals.fade_out()
