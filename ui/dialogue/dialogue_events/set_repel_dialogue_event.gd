extends DialogueEvent
class_name SetRepelDialogueEvent

@export var value: int
@export var source: String

func execute(window: DialogueWindow, params: Dictionary) -> void:
	await window.get_tree().process_frame
	var controller: FieldMapController = params.get("map_controller") as FieldMapController
	controller.hero_character.repel_steps = value
	controller.hero_character.repel_source = source
