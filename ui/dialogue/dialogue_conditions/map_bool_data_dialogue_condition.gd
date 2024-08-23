extends DialogueCondition
class_name MapBoolDataDialogueCondition

@export var map_key: String
@export var data_key: String

func evaluate(_window: DialogueWindow, _params: Dictionary) -> bool:
	return GameDataManager.get_map_bool(map_key, data_key)
