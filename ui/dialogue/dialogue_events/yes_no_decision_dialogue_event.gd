extends DialogueEvent
class_name YesNoDecisionDialogueEvent

signal event_executed()

@export var yes_event: DialogueEvent
@export var no_event: DialogueEvent


func execute(window: DialogueWindow, params: Dictionary) -> void:
	await window.prompt_yes_no(execute_yes.bind(window, params), execute_no.bind(window, params))
	await event_executed


func execute_yes(window: DialogueWindow, params: Dictionary) -> void:
	if yes_event != null:
		await window.show_newline()
		await yes_event.execute(window, params)
	event_executed.emit()


func execute_no(window: DialogueWindow, params: Dictionary) -> void:
	if no_event != null:
		await window.show_newline()
		await no_event.execute(window, params)
	event_executed.emit()
	
