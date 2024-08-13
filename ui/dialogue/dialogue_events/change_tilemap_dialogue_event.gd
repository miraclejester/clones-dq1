extends DialogueEvent
class_name ChangeTilemapDialogueEvent

@export var target_pos: Vector2
@export var tile_key: String


func execute(window: DialogueWindow, params: Dictionary) -> void:
	var map: FieldMap = params.get("map") as FieldMap
	map.field_tile_map.set_tile_key(target_pos, tile_key)
	await window.get_tree().process_frame
