extends Node2D
class_name HeroCharacter

enum MoveState {
	IDLE, FACING, MOVING
}

@export var move_speed: float = 32
@export var facing_wait_time: float = 0.2

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var move_timer: Timer = %MoveTimer


var target_pos: Vector2
var moving: bool = false
var current_map: FieldTileMap
var facing_dir: Vector2 = Vector2.DOWN
var move_state: MoveState = MoveState.IDLE
var tracked_input: String

var dir_anim_dict: Dictionary = {
	Vector2.DOWN : "walk_down",
	Vector2.LEFT : "walk_left",
	Vector2.UP : "walk_up",
	Vector2.RIGHT : "walk_right"
}

var move_input_dict: Dictionary = {
	"down" : Vector2.DOWN,
	"left" : Vector2.LEFT,
	"up" : Vector2.UP,
	"right" : Vector2.RIGHT
}

func _ready() -> void:
	set_face_dir(Vector2.DOWN)
	move_timer.timeout.connect(on_move_timer_timeout)


func _process(delta: float) -> void:
	process_movement(delta)


func set_current_map(map: FieldTileMap) -> void:
	current_map = map


func process_movement(delta: float) -> void:
	match move_state:
		MoveState.IDLE:
			check_movement_input()
		MoveState.FACING:
			if Input.is_action_just_released(tracked_input):
				move_timer.stop()
				move_state = MoveState.IDLE
		MoveState.MOVING:
			position = position.move_toward(target_pos, delta * move_speed)
			if position.is_equal_approx(target_pos):
				position = target_pos
				var move: String = get_cur_move_input()
				if move != "":
					var target: Vector2 = move_input_dict.get(move, Vector2.DOWN)
					set_face_dir(target)
					set_target_dir(target)
				else:
					move_state = MoveState.IDLE


func check_movement_input() -> void:
	var move: String = get_cur_move_input()
	if move != "":
		var target: Vector2 = move_input_dict.get(move, Vector2.DOWN)
		set_face_dir(target)
		move_timer.start(facing_wait_time)
		tracked_input = move
		move_state = MoveState.FACING


func get_cur_move_input() -> String:
	for mov in ["down", "up", "left", "right"]:
		if Input.is_action_pressed(mov):
			return mov
	return ""


func set_target_dir(dir: Vector2) -> void:
	var target: Vector2 = position + dir * 16
	if not current_map.request_move(target):
		return
	target_pos = position + dir * 16
	move_state = MoveState.MOVING


func set_face_dir(dir: Vector2) -> void:
	animation_player.play(dir_anim_dict.get(dir, "walk_down"))
	facing_dir = dir


func on_move_timer_timeout() -> void:
	set_target_dir(facing_dir)
