extends DialogueEvent
class_name GoOutsideDialogueEvent

func execute(window: DialogueWindow, params: Dictionary) -> void:
	var controller: FieldMapController = params.get("map_controller") as FieldMapController
	window.auto_continue = true
	await controller.transition_to_map(controller.field_map.outside_target, controller.field_map.outside_map_params)
