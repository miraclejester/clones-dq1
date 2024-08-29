extends Node2D
class_name FieldCharacter

@export var starting_face_dir: Vector2 = Vector2.DOWN
@export var static_char: bool = false
@export var changes_face_dir: bool = true

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var sprite: Sprite2D = %Sprite2D
@onready var field_move_component: FieldMoveComponent = %FieldMoveComponent

var facing_dir: Vector2 = Vector2.DOWN
var current_map: FieldMap

var dir_anim_dict: Dictionary = {
	Vector2.DOWN : "walk_down",
	Vector2.LEFT : "walk_left",
	Vector2.UP : "walk_up",
	Vector2.RIGHT : "walk_right"
}

var pause_frame_dict: Dictionary = {
	"walk_down" : 0,
	"walk_left" : 2,
	"walk_up" : 4,
	"walk_right" : 6
}


func _ready() -> void:
	set_face_dir(starting_face_dir, true)


func set_current_map(map: FieldMap) -> void:
	current_map = map


func set_face_dir(dir: Vector2, force: bool = false) -> void:
	if not changes_face_dir:
		return
	if static_char and not force:
		return
	var base: String = dir_anim_dict.get(dir, "walk_down")
	
	if not static_char:
		animation_player.play(get_move_anim_name(base))
	facing_dir = dir
	if get_tree().paused or static_char:
		sprite.frame = get_pause_frame(base)


func play_custom_anim(anim_name: String) -> void:
	animation_player.play(anim_name)


func set_frame(frame: int) -> void:
	sprite.frame = frame


func get_move_anim_name(base: String) -> String:
	return "basic_character_move/%s" % base


func get_pause_frame(base: String) -> int:
	return pause_frame_dict.get(base, 0)


func face_towards(pos: Vector2) -> void:
	var dir: Vector2 = (pos - position).normalized()
	set_face_dir(dir)


func get_facing_tile_position() -> Vector2:
	return position + facing_dir * 16


func cancel_move() -> void:
	field_move_component.cancel_move()
