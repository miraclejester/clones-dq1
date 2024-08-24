extends DialogueCondition
class_name RandomChanceDialogueCondition

@export var chance: float

func evaluate(_window: DialogueWindow, _params: Dictionary) -> bool:
	return randf_range(0, 1) < chance
