extends Sprite2D
class_name EnemyController

signal on_appear_finished()

@export var appear_material: ShaderMaterial

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var enemy_data: EnemyData


func set_data(d: EnemyData) -> void:
	texture = d.texture
	position = d.get_position_from_group()
	enemy_data = d


func play_appear_animation(anim_speed: float = 1.0) -> void:
	material = appear_material
	animation_player.play("appear", -1, anim_speed)
	await animation_player.animation_finished


func play_hurt_animation() -> void:
	animation_player.play("hurt")
	await animation_player.animation_finished


func apply_hurt_texture() -> void:
	texture = enemy_data.hurt_texture


func remove_hurt_texture() -> void:
	texture = enemy_data.texture
