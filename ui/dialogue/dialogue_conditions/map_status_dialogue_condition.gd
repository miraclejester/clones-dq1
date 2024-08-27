extends DialogueCondition
class_name MapStatusDialogueCondition

enum StatusCheck {
	IS_DARK,
	HAS_OUTSIDE_TARGET,
	HAS_TAG,
	PLAYER_IS_FACING_POSITION
}

@export var status_check: StatusCheck
@export var tag: FieldMap.MapTag
@export var vec2_value: Vector2

func evaluate(_window: DialogueWindow, params: Dictionary) -> bool:
	var controller: FieldMapController = params.get("map_controller") as FieldMapController
	match status_check:
		StatusCheck.IS_DARK:
			return controller.field_map.is_dark
		StatusCheck.HAS_OUTSIDE_TARGET:
			return controller.field_map.outside_target != ""
		StatusCheck.HAS_TAG:
			return controller.field_map.has_tag(tag)
		StatusCheck.PLAYER_IS_FACING_POSITION:
			var pos: Vector2 = controller.hero_character.get_facing_tile_position()
			return pos.is_equal_approx(vec2_value)
	return false
