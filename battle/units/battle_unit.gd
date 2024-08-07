extends Node
class_name BattleUnit

enum StatusEffect {
	SLEEP, STOPSPELL
}

@export var sleep_started_dialogue: DialogueEvent
@export var sleep_continues_dialogue: DialogueEvent
@export var awake_dialogue: DialogueEvent
@export var stopspell_dialogue: DialogueEvent

@onready var stats: UnitStats = %UnitStats

var crit_chance: float = 0
var spells: Array[SpellData] = []
var status_dict: Dictionary = {} #StatusEffect to bool
var sleep_turns: int = 0

func process_turn(_battle: Battle) -> void:
	pass


func get_deal_damage_update(_damage: int, _new_hp: int) -> BattleUpdate:
	return null


func get_sleep_started_format_vars() -> Array:
	return []


func get_sleep_continues_format_vars() -> Array:
	return []


func get_awake_format_vars() -> Array:
	return [get_unit_name()]


func deal_damage(damage: int) -> void:
	stats.modify_stat(UnitStats.StatKey.HP, -damage)


func has_status(key: StatusEffect) -> bool:
	return status_dict.has(key)


func add_status(key: StatusEffect) -> void:
	status_dict[key] = true


func remove_status(key: StatusEffect) -> void:
	status_dict.erase(key)


func clear_status() -> void:
	status_dict.clear()


func hurt_hit_check() -> bool:
	return true


func sleep_hit_check() -> bool:
	return true


func stopspell_hit_check() -> bool:
	return true


func sleep_wake_check(turns: int) -> bool:
	return turns >= 6 or randf_range(0.0, 1.0) < 0.5 


func get_attack_damage(defender: BattleUnit) -> int:
	var diff: int = (get_attack() - floor(defender.get_defense() / 2.0))
	var min_damage: int = floor(diff / 4.0)
	var max_damage: int = floor(diff / 2.0)
	return randi_range(min_damage, max_damage)


func get_crit_damage() -> int:
	return randi_range(floor(get_attack() / 2.0), get_attack())


func get_defense() -> int:
	return floor(stats.get_stat(UnitStats.StatKey.AGI) / 2.0)


func get_attack() -> int:
	return stats.get_stat(UnitStats.StatKey.STR)


func get_dodge() -> float:
	return 0


func is_dead() -> bool:
	return stats.get_stat(UnitStats.StatKey.HP) <= 0 


func get_unit_name() -> String:
	return "Generic Unit"


func get_attack_sfx_key() -> SFXEntry.SFXKey:
	return SFXEntry.SFXKey.Attack
