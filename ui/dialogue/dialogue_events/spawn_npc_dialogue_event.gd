extends DialogueEvent
class_name SpawnNPCDialogueEvent

@export var npc_scene: PackedScene
@export var pos: Vector2

func execute(window: DialogueWindow, params: Dictionary) -> void:
	await window.get_tree().process_frame
	var controller: FieldMapController = params.get("map_controller") as FieldMapController
	controller.field_map.spawn_character(npc_scene, pos)
