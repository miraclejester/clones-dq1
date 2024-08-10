extends CanvasLayer
class_name FieldUI

@onready var visuals_parent: Control = $VisualsParent
@onready var player_hud: PlayerHUD = %PlayerHud


func _ready() -> void:
	for child in visuals_parent.get_children():
		(child as Control).visible = false
	set_hero(PlayerManager.hero)


func set_hero(hero: HeroUnit) -> void:
	player_hud.set_hero(hero)


func show_hud() -> void:
	player_hud.visible = true


func hide_hud() -> void:
	player_hud.visible = false
