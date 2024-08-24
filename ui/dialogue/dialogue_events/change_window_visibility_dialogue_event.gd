extends DialogueEvent
class_name ChangeWindowVisibilityDialogueEvent

@export var make_visible: bool = true

func execute(window: DialogueWindow, _params: Dictionary) -> void:
	await window.get_tree().process_frame
	window.visible = make_visible
