extends DialogueCondition
class_name MapStatusDialogueCondition

enum StatusCheck {
	IS_DARK
}

@export var status_check: StatusCheck

func evaluate(_window: DialogueWindow, params: Dictionary) -> bool:
	var controller: FieldMapController = params.get("map_controller") as FieldMapController
	match status_check:
		StatusCheck.IS_DARK:
			return controller.field_map.is_dark
	return false
