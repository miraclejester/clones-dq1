extends Node2D
class_name EncounterZone

@export var encounter_chances: EncounterChanceChart
@export var encounters: Array[EncounterData]
@export var battle_bg: Texture2D

@onready var start_position: Node2D = %StartPosition as Node2D
@onready var end_position: Node2D = %EndPosition as Node2D

var chances_dict: Dictionary = {}

func _ready() -> void:
	for entry in encounter_chances.chances:
		chances_dict[entry.battle_id] = entry.chance


func is_in_zone(pos: Vector2) -> bool:
	var is_h: bool = pos.x >= start_position.global_position.x and pos.x <= end_position.global_position.x
	var is_v: bool = pos.y >= start_position.global_position.y and pos.y <= end_position.global_position.y
	return is_h and is_v


func get_encounter_chance(id: EncounterChanceEntry.TileBattleID) -> float:
	return chances_dict.get(id, 0)


func roll_for_battle(id: EncounterChanceEntry.TileBattleID) -> EncounterData:
	var roll: float = randf_range(0, 1)
	if roll < get_encounter_chance(id):
		return encounters.pick_random()
	else:
		return null
