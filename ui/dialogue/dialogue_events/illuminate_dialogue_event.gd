extends DialogueEvent
class_name IlluminateDialogueEvent

@export var strength: int = 1
@export var batteries: Array[int] = []

func execute(window: DialogueWindow, params: Dictionary) -> void:
	await window.get_tree().process_frame
	var controller: FieldMapController = params.get("map_controller") as FieldMapController
	
	controller.initialize_darkness()
	for i in range(1, strength + 1):
		controller.illuminate(i, batteries[i-1])
		await AudioManager.play_sfx("illuminate")
	window.auto_continue = true
