extends VBoxContainer
class_name DialogueParagraph

@export var dialogue_line_scene: PackedScene

var word_index: int = 0
var split_text: Array[String]
var data: PlayParagraphDialogueEvent
var wrap_length: int
var custom_label_settings: LabelSettings


func play_paragraph(d: PlayParagraphDialogueEvent, format_vars: Array = [], word_wrap_length: int = 177) -> void:
	var formatted_text = d.text % format_vars
	split_text.assign(formatted_text.split(" "))
	word_index = 0
	wrap_length = word_wrap_length
	data = d
	await play_next_line()


func start_paragraph(d: PlayParagraphDialogueEvent, format_vars: Array = [], word_wrap_length: int = 177) -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()
	await play_paragraph(d, format_vars, word_wrap_length)


func play_next_line() -> void:
	if word_index >= split_text.size():
		return
	var line: DialogueLine = dialogue_line_scene.instantiate() as DialogueLine
	add_child(line)
	if custom_label_settings:
		line.custom_label_settings = custom_label_settings
	await line.play_line(get_next_line_text(), data.is_speech)
	await play_next_line()
	

func get_next_line_text() -> String:
	var res: String = ""
	if data.in_quotes:
		if word_index == 0:
			split_text[word_index] = '~' + split_text[word_index]
		else:
			split_text[word_index] = ' ' + split_text[word_index]
	var cur_length: int = 0
	var idx: int = word_index
	if idx < split_text.size() - 1 and cur_length + ((split_text[idx].length() + 1) * 8) <= wrap_length:
		split_text[idx] += ' '
	while idx < split_text.size() and cur_length + (split_text[idx].length() * 8) <= wrap_length:
		cur_length += (split_text[idx].length()) * 8
		res += split_text[idx]
		idx += 1
		if data.in_quotes and idx == split_text.size() - 1:
			split_text[idx] += "'"
		if idx < split_text.size() - 1 and cur_length + ((split_text[idx].length() + 1) * 8) <= wrap_length:
			split_text[idx] += ' '
	res = res.trim_suffix(" ")
	word_index = idx
	return res
