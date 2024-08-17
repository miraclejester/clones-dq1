extends HBoxContainer
class_name CommandLabel

signal selected(option: String)

@export var blink_time: float = 0.3

@onready var selector: TextureRect = $Selector
@onready var blink_timer: Timer = $BlinkTimer
@onready var label_text: Label = %LabelText
@onready var second_line: Label = %SecondLine
@onready var item_amount: Label = %ItemAmount


var max_line_length: int = 9


func _ready() -> void:
	move_away()
	blink_timer.timeout.connect(blink)


func highlight() -> void:
	selector.modulate.a = 0
	blink()


func move_away() -> void:
	blink_timer.stop()
	selector.modulate.a = 0


func select() -> void:
	selected.emit(label_text.text)


func set_text(t: String, multiline: bool, show_second_line: bool) -> void:
	var split: Array[String] = []
	split.assign(t.split(' '))
	label_text.text = ""
	if split.size() > 1 and multiline:
		while split.size() > 1:
			label_text.text += split.pop_front() + " "
		label_text.text.trim_suffix(" ")
		second_line.text = split[0]
		second_line.visible = true
	else:
		label_text.text = t
		second_line.text = ""
		second_line.visible = show_second_line


func set_amount(amount: int) -> void:
	item_amount.visible = amount > 1
	item_amount.text = str(amount)


func blink() -> void:
	if selector.modulate.a == 0:
		selector.modulate.a = 1
	else:
		selector.modulate.a = 0
	blink_timer.start(blink_time)
