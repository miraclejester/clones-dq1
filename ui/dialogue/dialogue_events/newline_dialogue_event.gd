extends PlayParagraphDialogueEvent
class_name NewlineDialogueEvent

func post_paragraph_create(w: DialogueWindow, p: DialogueParagraph) -> void:
	p.custom_label_settings = w.newline_settings
	use_format_vars = false
