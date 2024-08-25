extends Node2D
class_name FieldMap

enum MapTag {
	OUTDOORS,
	OVERWORLD
}

@export var map_bgm: String
@export var is_dark: bool
@export var map_start_event: DialogueEvent
@export var out_of_bounds_event: DialogueEvent
@export var outside_target: String
@export var outside_map_params: MapLoadParams
@export var map_tags: Array[MapTag]

@onready var field_tile_map: FieldTileMap = %FieldTileMap
@onready var npc_parent: Node2D = %NPCParent
@onready var event_parent: Node2D = %EventParent
@onready var spawn_points: Node2D = $SpawnPoints
@onready var building_npc_parent: Node2D = %BuildingNPCParent
@onready var encounter_data: Node2D = %EncounterData
@onready var bound_start: Node2D = %BoundStart
@onready var bound_end: Node2D = %BoundEnd


var char_dict: Dictionary #Vector2 to FieldCharacter
var event_dict: Dictionary #Vector2 to MapEvent


func _ready() -> void:
	for npc in npc_parent.get_children():
		var n: NPCCharacter = npc as NPCCharacter
		char_dict[n.position] = n
		n.set_current_map(self)
		n.activate_events()
	for npc in building_npc_parent.get_children():
		var n: NPCCharacter = npc as NPCCharacter
		char_dict[n.position] = n
		n.set_current_map(self)
		n.activate_events()
	register_events(event_parent)


func register_events(p: Node2D) -> void:
	for event in p.get_children():
		if event is MapEvent:
			var e: MapEvent = event as MapEvent
			event_dict[e.position] = e
		else:
			register_events(event)


func register_character(character: FieldCharacter, force: bool = false) -> void:
	if not char_dict.has(character.position) or force:
		char_dict[character.position] = character


func spawn_character(character_scene: PackedScene, pos: Vector2) -> void:
	var character: NPCCharacter = character_scene.instantiate() as NPCCharacter
	npc_parent.add_child(character)
	character.position = pos
	char_dict[character.position] = character
	character.set_current_map(self)
	character.activate_events()


func place_character_spot(character: FieldCharacter, pos: Vector2) -> void:
	char_dict[pos] = character


func move_character_register(old_pos: Vector2, character: FieldCharacter) -> void:
	char_dict.erase(old_pos)
	char_dict[character.position] = character


func request_move(target: Vector2, origin: Vector2, move_params: MapMoveParams = MapMoveParams.new()) -> bool:
	var is_available: bool = field_tile_map.request_move(target) and not is_pos_reserved(target)
	if move_params.skip_steps and is_available:
		var event: MapEvent = find_event(target)
		if event != null:
			is_available = event.step_event == null
	if move_params.skip_oob and is_available:
		is_available = not is_out_of_bounds(target)
	if move_params.skip_damage and is_available:
		is_available = get_tile_damage(target) <= 0
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


func get_events() -> Array[MapEvent]:
	var res: Array[MapEvent] = []
	res.assign(event_dict.values())
	return res


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


func building_entered() -> void:
	field_tile_map.building_entered()
	npc_parent.visible = false


func building_exited() -> void:
	field_tile_map.building_exited()
	npc_parent.visible = true


func get_encounter_zone(pos: Vector2) -> EncounterZone:
	for zone in encounter_data.get_children():
		var z: EncounterZone = zone as EncounterZone
		if z.is_in_zone(pos):
			return z
	return null


func get_tile_battle_id(pos: Vector2) -> EncounterChanceEntry.TileBattleID:
	return field_tile_map.get_tile_battle_id(pos)


func get_tile_damage(pos: Vector2) -> int:
	return field_tile_map.get_tile_damage(pos)


func is_out_of_bounds(pos: Vector2) -> bool:
	var out_left: bool = pos.x < bound_start.position.x
	var out_right: bool = pos.x > bound_end.position.x
	var out_up: bool = pos.y < bound_start.position.y
	var out_down: bool = pos.y > bound_end.position.y
	return out_left or out_right or out_up or out_down


func has_tag(tag: MapTag) -> bool:
	return map_tags.has(tag)
