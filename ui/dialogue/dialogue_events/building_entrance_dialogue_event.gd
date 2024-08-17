extends DialogueEvent
class_name BuildingEntranceDialogueEvent

@export var entered: bool = true

func execute(window: DialogueWindow, params: Dictionary) -> void:
	await window.get_tree().process_frame
	var controller: FieldMapController = params.get("map_controller") as FieldMapController
	if entered:
		controller.field_map.building_entered()
	else:
		controller.field_map.building_exited()
