extends TextureRect
class_name DialogueContinuator

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func blink() -> void:
	animation_player.play("blink")


func off() -> void:
	animation_player.play("off")
