extends Node2D
class_name FieldMap

@export var map_bgm: String
@export var map_start_event: DialogueEvent

@onready var field_tile_map: FieldTileMap = %FieldTileMap
@onready var npc_parent: Node2D = %NPCParent
@onready var event_parent: Node2D = %EventParent
@onready var spawn_points: Node2D = $SpawnPoints


var char_dict: Dictionary #Vector2 to NPCCharacter
var event_dict: Dictionary #Vector2 to MapEvent


func _ready() -> void:
	for npc in npc_parent.get_children():
		var n: NPCCharacter = npc as NPCCharacter
		char_dict[n.position] = n
		n.set_current_map(self)
		n.activate_events()
	for event in event_parent.get_children():
		var e: MapEvent = event as MapEvent
		event_dict[e.position] = e


func register_character(character: FieldCharacter) -> void:
	if not char_dict.has(character.position):
		char_dict[character.position] = character


func place_character_spot(character: FieldCharacter, pos: Vector2) -> void:
	char_dict[pos] = character


func move_character_register(old_pos: Vector2, character: FieldCharacter) -> void:
	char_dict.erase(old_pos)
	char_dict[character.position] = character


func request_move(target: Vector2, origin: Vector2, skip_step_events: bool = false) -> bool:
	var is_available: bool = field_tile_map.request_move(target) and not is_pos_reserved(target)
	if skip_step_events:
		var event: MapEvent = find_event(target)
		if event != null:
			is_available = event.step_event == null
	if is_available:
		char_dict[origin] = null
		char_dict[target] = null
	return is_available


func find_npc(pos: Vector2) -> NPCCharacter:
	return find_character(pos) as NPCCharacter


func find_character(pos: Vector2) -> FieldCharacter:
	return char_dict.get(pos, null) as FieldCharacter


func find_event(pos: Vector2) -> MapEvent:
	return event_dict.get(pos, null) as MapEvent


func remove_event(pos: Vector2) -> void:
	var event: MapEvent = find_event(pos)
	if event != null:
		event_dict.erase(pos)
		event.queue_free()


func is_pos_reserved(pos: Vector2) -> bool:
	return char_dict.has(pos)


func find_spawn_pos(key: String) -> Vector2:
	if spawn_points.get_child_count() == 0:
		return Vector2.ZERO
	for sp in spawn_points.get_children():
		var s: Node2D = sp as Node2D
		if s.name == key:
			return s.position
	return (spawn_points.get_child(0) as Node2D).position
