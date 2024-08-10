extends Node2D
class_name FieldCharacter

@export var starting_face_dir: Vector2 = Vector2.DOWN

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
	Vector2.DOWN : 0,
	Vector2.LEFT : 2,
	Vector2.UP : 4,
	Vector2.RIGHT : 6
}


func _ready() -> void:
	set_face_dir(starting_face_dir)


func set_current_map(map: FieldMap) -> void:
	current_map = map


func set_face_dir(dir: Vector2) -> void:
	var base: String = dir_anim_dict.get(dir, "walk_down")
	var anim_name: String = "basic_character_move/%s" % base
	animation_player.play(anim_name)
	facing_dir = dir
	if get_tree().paused:
		sprite.frame = pause_frame_dict.get(dir, 0)


func face_towards(pos: Vector2) -> void:
	var dir: Vector2 = (pos - position).normalized()
	set_face_dir(dir)


func get_facing_tile_position() -> Vector2:
	return position + facing_dir * 16
