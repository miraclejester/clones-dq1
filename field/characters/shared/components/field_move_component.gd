extends Node
class_name FieldMoveComponent

signal move_finished

@export var user: FieldCharacter
@export var move_speed: float = 48

var old_pos: Vector2
var target_pos: Vector2
var moving: bool = false


func _process(delta: float) -> void:
	if moving:
		move(delta)


func move(delta: float) -> void:
	user.position = user.position.move_toward(target_pos, delta * move_speed)
	if user.position.is_equal_approx(target_pos):
		user.position = target_pos
		user.current_map.move_character_register(old_pos, user)
		move_finished.emit()
		moving = false


func cancel_move() -> void:
	old_pos = user.position
	moving = false


func request_move(target: Vector2, skip_step_events: bool = false) -> bool:
	if not user.current_map.request_move(target, user.position, skip_step_events):
		return false
	old_pos = user.position
	target_pos = target
	moving = true
	return true
