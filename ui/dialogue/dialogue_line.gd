extends Control
class_name DialogueLine

signal line_finished()

@export var speech_sound_speed: float = 0.06

@onready var line_label: Label = $LineLabel


var letter_index: int = 0
var current_text: String
var custom_label_settings: LabelSettings
var playing: bool = false
var letter_speed: float = 0.035

func _ready() -> void:
	letter_speed = GameSettings.get_message_speed()


func play_line(text: String, is_speech: bool = false) -> void:
	playing = true
	current_text = text
	letter_index = 0
	line_label.text = ""
	if custom_label_settings:
		line_label.label_settings = custom_label_settings
	if is_speech:
		play_speech_sounds()
	while letter_index < current_text.length():
		line_label.text += current_text[letter_index]
		letter_index += 1
		if letter_index < current_text.length():
			await get_tree().create_timer(letter_speed).timeout
	playing = false


func play_speech_sounds() -> void:
	await get_tree().create_timer(0.05).timeout
	while playing:
		AudioManager.play_sfx("speech_blip")
		await get_tree().create_timer(speech_sound_speed).timeout
