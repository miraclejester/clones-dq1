extends DialogueEvent
class_name SequenceDialogueEvent

@export var events: Array[DialogueEvent]

func execute(window: DialogueWindow, params: Dictionary) -> void:
	for event in events:
		await event.execute(window, params)
