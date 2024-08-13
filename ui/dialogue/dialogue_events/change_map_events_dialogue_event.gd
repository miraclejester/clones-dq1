extends DialogueEvent
class_name ChangeMapEventsDialogueEvent

enum EventOperation {
	REMOVE
}

@export var target_pos: Vector2
@export var operation: EventOperation

func execute(window: DialogueWindow, params: Dictionary) -> void:
	var map: FieldMap = params.get("map") as FieldMap
	match operation:
		EventOperation.REMOVE:
			map.remove_event(params.get("change_map_event_target_pos", target_pos))
	await window.get_tree().process_frame
