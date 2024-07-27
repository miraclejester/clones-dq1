extends Sprite2D
class_name EnemyController

signal on_appear_finished()

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func set_data(d: EnemyData) -> void:
	texture = d.texture
	set_appear_palette(d.appear_palette)
	position = d.get_position_from_group()


func play_appear_animation() -> AnimationPlayer:
	animation_player.play("appear")
	return animation_player


func set_appear_palette(palette: Texture2D) -> void:
	(material as ShaderMaterial).set_shader_parameter("palette", palette)
