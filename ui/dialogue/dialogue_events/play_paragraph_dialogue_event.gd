extends DialogueEvent
class_name PlayParagraphDialogueEvent

enum ParagraphEventKeys {
	FORMAT_VARS,
	CONTINUING,
	WORD_WRAP_LENGTH
}

@export_multiline var text: String
@export var in_quotes: bool = false

func execute(window: DialogueWindow, params: Dictionary) -> void:
	var continuing: bool = params.get(ParagraphEventKeys.CONTINUING, false)
	var word_wrap_length: int = params.get(ParagraphEventKeys.WORD_WRAP_LENGTH, 177)
	var paragraph: DialogueParagraph
	if continuing:
		paragraph = window.current_paragraph
		paragraph.custom_label_settings = window.standard_settings
	else:
		paragraph = window.create_paragraph()
	post_paragraph_create(window, paragraph)
	paragraph.paragraph_finished.connect(finish, CONNECT_ONE_SHOT)
	paragraph.play_paragraph(self, params.get(ParagraphEventKeys.FORMAT_VARS, []), word_wrap_length)


func post_paragraph_create(w: DialogueWindow, p: DialogueParagraph) -> void:
	p.custom_label_settings = w.standard_settings
