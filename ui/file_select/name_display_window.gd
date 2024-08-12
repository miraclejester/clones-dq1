extends Control
class_name NameDisplayWindow

signal name_filled(final_name: String)

@onready var current_name: Label = %CurrentName
@onready var floor_label: Label = %Floor

var max_index: int = 8
var cur_index: int = 0

func reset() -> void:
	current_name.text = "********"
	cur_index = 0
	refresh_floor()


func set_letter(letter: String) -> void:
	current_name.text[cur_index] = letter
	cur_index += 1
	refresh_floor()
	if cur_index >= max_index:
		name_filled.emit(get_final_name())


func go_back() -> void:
	if cur_index == 0:
		return
	cur_index -= 1
	refresh_floor()


func refresh_floor() -> void:
	floor_label.text = ""
	for i in range(max_index):
		if i == cur_index:
			floor_label.text += "_"
		else:
			floor_label.text += " "


func get_final_name() -> String:
	if current_name.text == "********":
		return "    "
	else:
		return current_name.text.substr(0, cur_index).trim_suffix(" ")
