extends Control
class_name DialogueLine

signal line_finished()

@export var letter_speed: float = 0.035

@onready var line_label: Label = $LineLabel
@onready var letter_timer: Timer = $LetterTimer


var letter_index: int = 0
var current_text: String
var custom_label_settings: LabelSettings

func _ready() -> void:
	letter_timer.timeout.connect(letter_timeout)


func play_line(text: String) -> void:
	current_text = text
	letter_index = 0
	line_label.text = ""
	if custom_label_settings:
		line_label.label_settings = custom_label_settings
	letter_timeout()


func letter_timeout() -> void:
	line_label.text += current_text[letter_index]
	letter_index += 1
	if letter_index < current_text.length():
		letter_timer.start(letter_speed)
	else:
		line_finished.emit()
