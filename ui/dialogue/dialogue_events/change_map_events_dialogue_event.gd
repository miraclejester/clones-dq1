extends DialogueEvent
class_name ChangeMapEventsDialogueEvent

enum EventOperation {
	REMOVE,
	REMOVE_DOOR
}

@export var target_pos: Vector2
@export var operation: EventOperation

func execute(window: DialogueWindow, params: Dictionary) -> void:
	var map: FieldMap = params.get("map") as FieldMap
	var pos: Vector2 = params.get("change_map_event_target_pos", target_pos) as Vector2
	match operation:
		EventOperation.REMOVE:
			map.remove_event(pos)
		EventOperation.REMOVE_DOOR:
			var event: MapEvent = map.find_event(pos)
			event.door_event = null
	await window.get_tree().process_frame
