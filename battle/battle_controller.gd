extends Node2D
class_name BattleController

@onready var battle_bg: BattleBG = $BattleBG
@onready var enemy_sprite: Sprite2D = $Enemy

func _ready() -> void:
	start_battle()


func start_battle() -> void:
	await battle_bg.start_appear_animation()
	enemy_sprite.visible = true
