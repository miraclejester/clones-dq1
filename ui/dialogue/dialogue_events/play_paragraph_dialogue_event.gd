extends DialogueEvent
class_name PlayParagraphDialogueEvent

enum ParagraphEventKeys {
	FORMAT_VARS,
	WORD_WRAP_LENGTH
}

@export_multiline var text: String
@export var in_quotes: bool = false
@export var wait_for_input: bool = false

func execute(window: DialogueWindow, params: Dictionary) -> void:
	var word_wrap_length: int = params.get(ParagraphEventKeys.WORD_WRAP_LENGTH, 177)
	var paragraph: DialogueParagraph
	paragraph = window.current_paragraph
	paragraph.custom_label_settings = window.standard_settings
	post_paragraph_create(window, paragraph)
	await paragraph.play_paragraph(self, params.get(ParagraphEventKeys.FORMAT_VARS, []), word_wrap_length)
	if wait_for_input:
		await window.wait_for_continuation(true)
	else:
		await window.get_tree().create_timer(0.15).timeout


func post_paragraph_create(w: DialogueWindow, p: DialogueParagraph) -> void:
	p.custom_label_settings = w.standard_settings
