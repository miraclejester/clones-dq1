extends DialogueEvent
class_name BranchDialogueEvent

@export var condition: DialogueCondition
@export var condition_true_event: DialogueEvent
@export var condition_false_event: DialogueEvent

func execute(window: DialogueWindow, params: Dictionary) -> void:
	await window.get_tree().process_frame
	if condition.evaluate(window, params):
		if condition_true_event != null:
			await condition_true_event.execute(window, params)
	elif condition_false_event != null:
		await condition_false_event.execute(window, params)
		
