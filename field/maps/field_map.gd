extends Node2D
class_name FieldMap

@export var map_bgm: BGMEntry.BGMKey

@onready var field_tile_map: FieldTileMap = %FieldTileMap
@onready var npc_parent: Node2D = %NPCParent


var char_dict: Dictionary #Vector2 to NPCCharacter


func _ready() -> void:
	for npc in npc_parent.get_children():
		var n: NPCCharacter = npc as NPCCharacter
		char_dict[n.position] = n


func register_character(character: FieldCharacter) -> void:
	if not char_dict.has(character.position):
		char_dict[character.position] = character


func move_character_register(old_pos: Vector2, new_pos: Vector2) -> void:
	var character: FieldCharacter = find_character(old_pos)
	char_dict.erase(old_pos)
	char_dict[new_pos] = character


func request_move(target: Vector2) -> bool:
	return field_tile_map.request_move(target) and find_character(target) == null


func find_npc(pos: Vector2) -> NPCCharacter:
	return find_character(pos) as NPCCharacter


func find_character(pos: Vector2) -> FieldCharacter:
	return char_dict.get(pos, null) as FieldCharacter
