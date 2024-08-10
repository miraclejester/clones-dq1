extends Node2D
class_name FieldMap

@export var map_bgm: BGMEntry.BGMKey

@onready var field_tile_map: FieldTileMap = %FieldTileMap
@onready var npc_parent: Node2D = %NPCParent


var npc_dict: Dictionary #Vector2 to NPCCharacter


func _ready() -> void:
	for npc in npc_parent.get_children():
		var n: NPCCharacter = npc as NPCCharacter
		npc_dict[n.position] = n


func request_move(target: Vector2) -> bool:
	return field_tile_map.request_move(target)


func find_npc(pos: Vector2) -> NPCCharacter:
	return npc_dict.get(pos, null)
