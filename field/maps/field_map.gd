extends Node2D
class_name FieldMap

@export var map_bgm: String
@export var map_start_event: DialogueEvent

@onready var field_tile_map: FieldTileMap = %FieldTileMap
@onready var npc_parent: Node2D = %NPCParent
@onready var searchables_parent: Node2D = %SearchablesParent

var char_dict: Dictionary #Vector2 to NPCCharacter


func _ready() -> void:
	for npc in npc_parent.get_children():
		var n: NPCCharacter = npc as NPCCharacter
		char_dict[n.position] = n
		n.set_current_map(self)


func register_character(character: FieldCharacter) -> void:
	if not char_dict.has(character.position):
		char_dict[character.position] = character


func move_character_register(old_pos: Vector2, character: FieldCharacter) -> void:
	char_dict.erase(old_pos)
	char_dict[character.position] = character


func request_move(target: Vector2, origin: Vector2) -> bool:
	var is_available: bool = field_tile_map.request_move(target) and not is_pos_reserved(target)
	if is_available:
		char_dict[origin] = null
		char_dict[target] = null
	return is_available


func find_npc(pos: Vector2) -> NPCCharacter:
	return find_character(pos) as NPCCharacter


func find_character(pos: Vector2) -> FieldCharacter:
	return char_dict.get(pos, null) as FieldCharacter


func is_pos_reserved(pos: Vector2) -> bool:
	return char_dict.has(pos)
