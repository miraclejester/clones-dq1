extends DialogueEvent
class_name PlayCustomParagraphEvent

@export var dialogue: PlayParagraphDialogueEvent
@export var format_var_providers: Array[FormatVarProvider]

func execute(window: DialogueWindow, _params: Dictionary) -> void:
	await dialogue.execute(window, {
		PlayParagraphDialogueEvent.ParagraphEventKeys.FORMAT_VARS : get_format_vars() 
	})


func get_format_vars() -> Array:
	var res: Array = []
	for provider in format_var_providers:
		res.append(provider.get_format_var())
	return res
