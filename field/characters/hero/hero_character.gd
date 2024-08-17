extends FieldCharacter
class_name HeroCharacter

signal idling()
signal move_intention()
signal menu_requested()
signal move_finished()

enum MoveState {
	IDLE, FACING, MOVING
}

@export var facing_wait_time: float = 0.2
@export var after_move_idle_wait_time: float = 1.5
@export var facing_idle_wait_time: float = 3.5
@export var wall_wait_time: float = 0.18

@onready var move_timer: Timer = %MoveTimer
@onready var idle_timer: Timer = %IdleTimer
@onready var wall_timer: Timer = %WallTimer


var target_pos: Vector2
var move_state: MoveState = MoveState.IDLE
var tracked_input: String
var old_pos: Vector2
var can_play_wall_sound: bool = true

var move_input_dict: Dictionary = {
	"down" : Vector2.DOWN,
	"left" : Vector2.LEFT,
	"up" : Vector2.UP,
	"right" : Vector2.RIGHT
}

func _ready() -> void:
	super()
	move_timer.timeout.connect(on_move_timer_timeout)
	idle_timer.timeout.connect(on_idle_timer_timeout)
	wall_timer.timeout.connect(on_wall_timer_timeout)
	field_move_component.move_finished.connect(func() : move_finished.emit())
	
	PlayerManager.hero.item_equipped.connect(on_item_equipped)


func _process(_delta: float) -> void:
	process_movement()


func process_movement() -> void:
	match move_state:
		MoveState.IDLE:
			check_menu_input()
			check_movement_input()
		MoveState.FACING:
			if Input.is_action_just_released(tracked_input):
				move_timer.stop()
				move_state = MoveState.IDLE
		MoveState.MOVING:
			if not field_move_component.moving:
				var move: String = get_cur_move_input()
				if move != "":
					var target: Vector2 = move_input_dict.get(move, Vector2.DOWN)
					set_face_dir(target)
					set_target_dir(target)
				else:
					idle_timer.start(after_move_idle_wait_time)
					move_state = MoveState.IDLE


func check_movement_input() -> void:
	var move: String = get_cur_move_input()
	if move != "":
		move_intention.emit()
		var target: Vector2 = move_input_dict.get(move, Vector2.DOWN)
		set_face_dir(target)
		move_timer.start(facing_wait_time)
		tracked_input = move
		idle_timer.start(facing_idle_wait_time)
		move_state = MoveState.FACING


func check_menu_input() -> void:
	if Input.is_action_just_pressed("A"):
		menu_requested.emit()


func get_cur_move_input() -> String:
	for mov in ["down", "up", "left", "right"]:
		if Input.is_action_pressed(mov):
			return mov
	return ""


func set_target_dir(dir: Vector2) -> void:
	idle_timer.start(after_move_idle_wait_time)
	if not field_move_component.request_move(position + dir * 16):
		if can_play_wall_sound:
			AudioManager.play_sfx("wall")
			can_play_wall_sound = false
			wall_timer.start(wall_wait_time)
		move_state = MoveState.IDLE
		return
	idle_timer.stop()
	move_state = MoveState.MOVING


func get_move_anim_name(base: String) -> String:
	return "%s%s" % [get_anim_prefix(), base]


func get_pause_frame(base: String) -> int:
	var base_frame: int = super(base)
	match get_anim_prefix():
		"full_":
			return base_frame + 24
		"sword_":
			return base_frame + 8
		"shield_":
			return base_frame + 16
		_:
			return base_frame


func get_anim_prefix() -> String:
	var has_weapon: bool = PlayerManager.hero.equipment.has_equip(EquipmentData.EquipmentType.WEAPON)
	var has_shield: bool = PlayerManager.hero.equipment.has_equip(EquipmentData.EquipmentType.SHIELD)
	var prefix: String = "basic_character_move/"
	if has_weapon and has_shield:
		prefix = "full_"
	elif has_weapon:
		prefix = "sword_"
	elif has_shield:
		prefix = "shield_"
	return prefix


func on_move_timer_timeout() -> void:
	set_target_dir(facing_dir)


func on_idle_timer_timeout() -> void:
	idling.emit()


func on_wall_timer_timeout() -> void:
	can_play_wall_sound = true


func on_item_equipped(_item: EquipmentData) -> void:
	set_face_dir(facing_dir)
