extends DialogueEvent
class_name MapTransitionDialogueEvent

@export var map_key: String
@export var load_params: MapLoadParams

func execute(window: DialogueWindow, params: Dictionary) -> void:
	await window.get_tree().process_frame
	window.auto_continue = true
	window.visible = false
	var controller: FieldMapController = params.get("map_controller") as FieldMapController
	await controller.transition_to_map(map_key, load_params)
