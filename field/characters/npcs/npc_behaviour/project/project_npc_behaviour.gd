extends NPCBehaviour
class_name ProjectNPCBehaviour

@export var project_dir: Vector2

func on_start() -> void:
	user.current_map.place_character_spot(user, user.position + project_dir * 16)
