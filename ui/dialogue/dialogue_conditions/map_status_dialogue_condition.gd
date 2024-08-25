extends DialogueCondition
class_name MapStatusDialogueCondition

enum StatusCheck {
	IS_DARK,
	HAS_OUTSIDE_TARGET,
	HAS_TAG
}

@export var status_check: StatusCheck
@export var tag: FieldMap.MapTag

func evaluate(_window: DialogueWindow, params: Dictionary) -> bool:
	var controller: FieldMapController = params.get("map_controller") as FieldMapController
	match status_check:
		StatusCheck.IS_DARK:
			return controller.field_map.is_dark
		StatusCheck.HAS_OUTSIDE_TARGET:
			return controller.field_map.outside_target != ""
		StatusCheck.HAS_TAG:
			return controller.field_map.has_tag(tag)
	return false
