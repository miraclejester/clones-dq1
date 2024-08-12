extends Node2D
class_name TitleScreen

@export var next_scene: PackedScene

@onready var full_screen: Sprite2D = %FullScreen
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var steps: Array[Callable]  = [
	reveal_full,
	go_to_next
]

var step_index = 0


func _ready() -> void:
	AudioManager.play_bgm("title")
	await get_tree().create_timer(9.56).timeout
	if step_index == 0:
		next_step()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("start"):
		next_step()


func next_step() -> void:
	var idx: int = step_index
	step_index += 1
	steps[idx].call()


func reveal_full() -> void:
	full_screen.visible = true
	animation_player.play("spark")


func go_to_next() -> void:
	get_tree().change_scene_to_packed(next_scene)
