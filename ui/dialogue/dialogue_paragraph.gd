extends VBoxContainer
class_name DialogueParagraph

signal paragraph_finished()

@export var dialogue_line_scene: PackedScene

var word_index: int = 0
var split_text: Array[String]
var data: PlayParagraphDialogueEvent
var wrap_length: int


func play_paragraph(d: PlayParagraphDialogueEvent, format_vars: Array = [], word_wrap_length: int = 177) -> void:
	var formatted_text = d.text % format_vars
	split_text.assign(formatted_text.split(" "))
	word_index = 0
	wrap_length = word_wrap_length
	data = d
	play_next_line()


func start_paragraph(d: PlayParagraphDialogueEvent, format_vars: Array = [], word_wrap_length: int = 177) -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()
	play_paragraph(d, format_vars, word_wrap_length)


func play_next_line() -> void:
	if word_index >= split_text.size():
		paragraph_finished.emit()
		return
	var line: DialogueLine = dialogue_line_scene.instantiate() as DialogueLine
	add_child(line)
	line.line_finished.connect(play_next_line, CONNECT_ONE_SHOT)
	line.play_line(get_next_line_text())
	

func get_next_line_text() -> String:
	var res: String = ""
	if data.in_quotes:
		if word_index == 0:
			res += '~'
		else:
			res += ' '
	var cur_length: int = 0
	var idx: int = word_index
	while idx < split_text.size() and cur_length + (split_text[idx].length() * 8) <= wrap_length:
		var spaces: int = 1
		if cur_length == 0 and data.in_quotes:
			spaces += 1
		cur_length += (split_text[idx].length() + spaces) * 8
		res += split_text[idx] + ' '
		idx += 1
	res = res.trim_suffix(" ")
	word_index = idx
	if word_index >= split_text.size() and data.in_quotes:
		res += "'"
	return res
