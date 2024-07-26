extends HBoxContainer
class_name CommandLabel

signal selected(option: String)

@export var blink_time: float = 0.3

@onready var selector: TextureRect = $Selector
@onready var blink_timer: Timer = $BlinkTimer
@onready var label_text: Label = $LabelText


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


func blink() -> void:
	if selector.modulate.a == 0:
		selector.modulate.a = 1
	else:
		selector.modulate.a = 0
	blink_timer.start(blink_time)
