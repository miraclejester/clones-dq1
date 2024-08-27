extends DialogueEvent
class_name DistanceToTileDialogueEvent

@export var base_dialogue: DialogueEvent
@export var tile_pos: Vector2

func execute(window: DialogueWindow, params: Dictionary) -> void:
	var controller: FieldMapController = params.get("map_controller") as FieldMapController
	var hero_pos: Vector2 = controller.hero_character.position
	
	var vertical_distance: int = floor((tile_pos.y - hero_pos.y) / 16)
	var vertical_name: String = "south"
	if vertical_distance < 0:
		vertical_name = "north"
	
	var horizontal_distance: int = floor((tile_pos.x - hero_pos.x) / 16)
	var horizontal_name: String = "east"
	if horizontal_distance < 0:
		horizontal_name = "west"
	
	
	if vertical_distance == 0 and horizontal_distance == 0:
		await window.get_tree().process_frame
		return
	
	var location_sentence: String = ""
	if vertical_distance != 0 and horizontal_distance != 0:
		location_sentence = "%d to the %s and| %d to the %s" % [abs(vertical_distance), vertical_name, abs(horizontal_distance), horizontal_name]
	elif vertical_distance != 0:
		location_sentence = "%d to the %s" % [abs(vertical_distance), vertical_name]
	elif horizontal_distance != 0:
		location_sentence = "%d to the %s" % [abs(horizontal_distance), horizontal_name]
	
	await window.start_dialogue([
		DialogueEventParams.fromData(base_dialogue, {
			PlayParagraphDialogueEvent.ParagraphEventKeys.FORMAT_VARS: [location_sentence]
		})
	])
	await window.wait_for_continuation(true)
