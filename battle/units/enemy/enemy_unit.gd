extends BattleUnit
class_name EnemyUnit

@export var enemy_data: EnemyData

var data: EnemyData

func _ready() -> void:
	set_stats_from_data(enemy_data)

func set_stats_from_data(ed: EnemyData) -> void:
	data = ed
	stats.set_strength(ed.stats.strength)
	stats.set_agility(ed.stats.agility)
	stats.set_max_hp(randi_range(ed.stats.min_hp, ed.stats.max_hp))
	stats.set_max_mp(0)


func get_attack_damage(defender: BattleUnit) -> int:
	if defender.get_defense() >= stats.strength:
		return randi_range(0, floor((stats.strength + 4) / 6.0))
	return super(defender)


func get_dodge() -> float:
	return data.stats.dodge


func get_xp() -> int:
	return data.stats.xp


func get_gp() -> int:
	return randi_range(data.stats.min_gp, data.stats.max_gp)


func get_group_factor() -> float:
	match data.initiative_group:
		1:
			return 0.25
		2:
			return 0.375
		3:
			return 0.5
		4, _:
			return 1
