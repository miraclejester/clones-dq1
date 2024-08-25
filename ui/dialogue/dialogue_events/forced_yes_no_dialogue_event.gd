extends DialogueEvent
class_name ForcedYesNoDialogueEvent

signal event_executed

@export var initial_event: DialogueEvent
@export var no_event: DialogueEvent

func execute(window: DialogueWindow, params: Dictionary) -> void:
	await initial_event.execute(window, params)
	await window.prompt_yes_no(execute_yes.bind(window, params), execute_no.bind(window, params))
	await event_executed


func execute_yes(_window: DialogueWindow, _params: Dictionary) -> void:
	event_executed.emit()


func execute_no(window: DialogueWindow, params: Dictionary) -> void:
	if no_event != null:
		await no_event.execute(window, params)
		await window.show_newline()
		await initial_event.execute(window, params)
		await window.prompt_yes_no(execute_yes.bind(window, params), execute_no.bind(window, params))
