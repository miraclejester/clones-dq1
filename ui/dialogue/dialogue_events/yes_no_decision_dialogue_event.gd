extends DialogueEvent
class_name YesNoDecisionDialogueEvent

@export var yes_event: DialogueEvent
@export var no_event: DialogueEvent


func execute(window: DialogueWindow, params: Dictionary) -> void:
	var is_yes: bool = await window.prompt_yes_no()
	await window.show_newline()
	if is_yes and yes_event != null:
		await yes_event.execute(window, params)
	elif not is_yes and no_event != null:
		await no_event.execute(window, params)
