extends DialogueEvent
class_name ChangeMapEventsDialogueEvent

enum EventOperation {
	REMOVE,
	REMOVE_DOOR,
	REMOVE_STEP,
	REMOVE_NPC
}

@export var target_pos: Vector2
@export var operation: EventOperation

func execute(window: DialogueWindow, params: Dictionary) -> void:
	var map: FieldMap = params.get("map") as FieldMap
	var pos: Vector2 = params.get("change_map_event_target_pos", target_pos) as Vector2
	var event: MapEvent = map.find_event(pos)
	match operation:
		EventOperation.REMOVE:
			map.remove_event(pos)
		EventOperation.REMOVE_DOOR:
			event.door_event = null
		EventOperation.REMOVE_STEP:
			event.step_event = null
		EventOperation.REMOVE_NPC:
			map.remove_npc(pos)
	await window.get_tree().process_frame
