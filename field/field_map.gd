extends Node2D
class_name FieldMap

@onready var hero_character: HeroCharacter = %HeroCharacter
@onready var field_tile_map: FieldTileMap = $FieldTileMap
@onready var field_ui: FieldUI = $FieldUI


func _ready() -> void:
	hero_character.idling.connect(on_hero_idling)
	hero_character.move_intention.connect(on_hero_move_intention)
	hero_character.set_current_map(field_tile_map)


func on_hero_idling() -> void:
	field_ui.show_hud()


func on_hero_move_intention() -> void:
	field_ui.hide_hud()
