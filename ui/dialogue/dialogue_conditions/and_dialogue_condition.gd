extends DialogueCondition
class_name AndDialogueCondition

@export var conditions: Array[DialogueCondition]

func evaluate(window: DialogueWindow, params: Dictionary) -> bool:
	for condition in conditions:
		if not condition.evaluate(window, params):
			return false
	return true
