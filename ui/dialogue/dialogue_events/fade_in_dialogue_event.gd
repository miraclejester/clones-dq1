extends DialogueEvent
class_name FadeInDialogueEvent

func execute(_window: DialogueWindow, _params: Dictionary) -> void:
	await GlobalVisuals.fade_in()
