extends DialogueEvent
class_name PlayParagraphDialogueEvent

enum ParagraphEventKeys {
	FORMAT_VARS,
	WORD_WRAP_LENGTH
}

@export_multiline var text: String
@export var in_quotes: bool = false
@export var wait_for_input: bool = false
@export var use_format_vars: bool = true
@export var format_var_idxs: Array[int]

func execute(window: DialogueWindow, params: Dictionary) -> void:
	var word_wrap_length: int = params.get(ParagraphEventKeys.WORD_WRAP_LENGTH, 177)
	var paragraph: DialogueParagraph
	paragraph = window.current_paragraph
	paragraph.custom_label_settings = window.standard_settings
	post_paragraph_create(window, paragraph)
	var format_vars: Array = params.get(ParagraphEventKeys.FORMAT_VARS, [])
	var final_format_vars: Array = []
	
	if use_format_vars:
		if format_var_idxs.size() > 0:
			for idx in format_var_idxs:
				final_format_vars.append(format_vars[idx])
		else:
			final_format_vars.assign(format_vars)

	await paragraph.play_paragraph(self, final_format_vars, word_wrap_length)
	if wait_for_input:
		await window.wait_for_continuation(true)
	else:
		await window.get_tree().create_timer(0.15).timeout


func post_paragraph_create(w: DialogueWindow, p: DialogueParagraph) -> void:
	p.custom_label_settings = w.standard_settings
