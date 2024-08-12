extends Node

@export var experience_chart: Array[ExperienceChartEntry]

@onready var hero: HeroUnit = $Hero


func get_next_level_entry() -> ExperienceChartEntry:
	if hero.level >= 30:
		return null
	return experience_chart[hero.level]


func get_exp_for_next_level() -> int:
	var chart: ExperienceChartEntry = get_next_level_entry()
	if chart == null:
		return 0
	else:
		return chart.experience - hero.experience


func generate_save_data() -> Dictionary:
	return {
		"level": hero.level,
		"gold": hero.gold,
		"experience": hero.experience,
		"hero_name": hero.get_unit_name(),
		"hp": hero.stats.get_stat(UnitStats.StatKey.HP),
		"mp": hero.stats.get_stat(UnitStats.StatKey.MP),
		"items": hero.inventory.generate_save_data(),
		"equipment": hero.equipment.generate_save_data()
	}


func load_from_data(data: Dictionary) -> void:
	hero.set_stats_from_level(data.get("level", 1))
	hero.gold = data.get("gold", 0)
	hero.experience = data.get("experience", 0)
	hero.set_hero_name(data.get("hero_name", "NONAME"))
	hero.stats.set_stat(UnitStats.StatKey.HP, data.get("hp", 15))
	hero.stats.set_stat(UnitStats.StatKey.MP, data.get("mp", 0))
	
	var items: Array[Dictionary] = []
	items.assign(data.get("items", []))
	hero.inventory.load_from_data(items)
	
	var equipment: Array[int] = []
	equipment.assign(data.get("equipment", []))
	hero.equipment.load_from_data(equipment)
