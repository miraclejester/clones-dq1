extends DialogueEvent
class_name SaveMapDataDialogueEvent

@export var map_key: String
@export var data_key: String

func execute(window: DialogueWindow, _params: Dictionary) -> void:
	await window.get_tree().process_frame
	GameDataManager.save_map_data(map_key, data_key, get_value())


func get_value() -> Variant:
	return null
	
