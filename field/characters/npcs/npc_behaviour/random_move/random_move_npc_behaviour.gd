extends NPCBehaviour
class_name RandomMoveNPCBehaviour

@export var wait_time: float = 1

@onready var wait_timer: Timer = $WaitTimer

var possible_dirs: Array[Vector2] = [
	Vector2.DOWN, Vector2.LEFT, Vector2.UP, Vector2.RIGHT, Vector2.ZERO
]


func on_start() -> void:
	wait_timer.timeout.connect(check_move)
	wait_timer.start(wait_time)


func check_move() -> void:
	if not enabled:
		return
	var dir: Vector2 = possible_dirs.pick_random()
	if dir != Vector2.ZERO:
		var target: Vector2 = user.position + dir * 16
		user.set_face_dir(dir)
		var move_params: MapMoveParams = MapMoveParams.new(true, true, true)
		var successful_request = user.field_move_component.request_move(target, move_params)
		if successful_request:
			await user.field_move_component.move_finished
	wait_timer.start(wait_time)
