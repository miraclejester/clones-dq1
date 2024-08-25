extends DialogueCondition
class_name NotDialogueCondition

@export var condition: DialogueCondition

func evaluate(window: DialogueWindow, params: Dictionary) -> bool:
	return not condition.evaluate(window, params)
