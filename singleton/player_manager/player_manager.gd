extends Node

@export var experience_chart: Array[ExperienceChartEntry]

@onready var hero: HeroUnit = $Hero

func _ready() -> void:
	hero.spells = DebugUtils.debug_spells
	for item in DebugUtils.debug_items:
		hero.inventory.add_item(item)
	for equipment in DebugUtils.debug_equipment:
		hero.equipment.equip(equipment)
	hero.set_hero_name("Erdrick")
	hero.set_stats_from_level(1, true)
	#hero.stats.set_stat(UnitStats.StatKey.HP, 2)


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
