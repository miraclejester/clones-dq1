extends Node2D
class_name FieldMap

@onready var hero_character: HeroCharacter = %HeroCharacter
@onready var field_tile_map: FieldTileMap = $FieldTileMap

func _ready() -> void:
	hero_character.set_current_map(field_tile_map)
