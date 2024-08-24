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
		"equipment": hero.equipment.generate_save_data(),
		"spells": hero.spells.map(func (spell: SpellData): return spell.spell_id),
		"is_cursed": hero.is_cursed
	}


func load_from_data(data: Dictionary) -> void:
	hero.set_hero_name(data.get("hero_name", "NONAME"))
	hero.set_stats_from_level(data.get("level", 1))
	hero.gold = data.get("gold", 0)
	hero.experience = data.get("experience", 0)
	hero.stats.set_stat(UnitStats.StatKey.HP, data.get("hp", 15))
	hero.stats.set_stat(UnitStats.StatKey.MP, data.get("mp", 0))
	hero.is_cursed = data.get("is_cursed", false)
	
	var items: Array[Dictionary] = []
	items.assign(data.get("items", []))
	hero.inventory.load_from_data(items)
	
	hero.equipment.load_from_data(data.get("equipment", {}))
	
	var spell_ids: Array[int] = []
	spell_ids.assign(data.get("spells", []))
	hero.spells.assign(spell_ids.map(func(id: int): return GameDataManager.get_spell(id)))
