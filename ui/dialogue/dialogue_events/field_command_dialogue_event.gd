extends DialogueEvent
class_name FieldCommandDialogueEvent

enum CommandKey {
	DOOR
}

@export var command: CommandKey

func execute(window: DialogueWindow, params: Dictionary) -> void:
	await window.get_tree().process_frame
	var map: FieldMapController = params.get("map_controller") as FieldMapController
	match command:
		CommandKey.DOOR:
			await map.on_door_selected()
	
