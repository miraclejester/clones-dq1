extends Node
class_name BattleUnit

@onready var stats: UnitStats = %UnitStats

var crit_chance: float = 0
var spells: Array[SpellData] = []

func deal_damage(damage: int) -> void:
	stats.hp -= damage


func get_attack_damage(defender: BattleUnit) -> int:
	var diff: int = (get_attack() - floor(defender.get_defense() / 2.0))
	var min_damage: int = floor(diff / 4.0)
	var max_damage: int = floor(diff / 2.0)
	return randi_range(min_damage, max_damage)


func get_crit_damage() -> int:
	return randi_range(floor(get_attack() / 2.0), get_attack())


func get_defense() -> int:
	return floor(stats.agility / 2.0)


func get_attack() -> int:
	return stats.strength


func get_dodge() -> float:
	return 0


func is_dead() -> bool:
	return stats.hp <= 0 


func get_unit_name() -> String:
	return "Generic Unit"
