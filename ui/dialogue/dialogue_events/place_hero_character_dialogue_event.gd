extends DialogueEvent
class_name PlaceHeroCharacterDialogueEvent

@export var pos: Vector2

func execute(window: DialogueWindow, params: Dictionary) -> void:
	await window.get_tree().process_frame
	var controller: FieldMapController = params.get("map_controller") as FieldMapController
	var old_pos: Vector2 = controller.hero_character.position
	controller.hero_character.position = pos
	controller.field_map.move_character_register(old_pos, controller.hero_character)
