extends BattleUnit
class_name HeroUnit

@export_file var level_chart_path: String
@export_file var letter_values_path: String

var level_chart: Dictionary
var letter_values: Dictionary
var growth_value: int
var growth_sum: int
var hero_name: String

func _ready() -> void:
	level_chart = FileUtils.load_json_dict(level_chart_path)
	letter_values = FileUtils.load_json_dict(letter_values_path)
	crit_chance = 1.0 / 32.0
	set_hero_name("Erdrick")
	set_stats_from_level(1)


func get_attack_damage(defender: BattleUnit) -> int:
	var damage: int = super(defender)
	if damage < 1:
		var roll: int = randi_range(0, 1)
		if roll == 1:
			return 1
	return damage


func set_hero_name(new_name: String) -> void:
	hero_name = new_name
	process_growth_value()


func set_stats_from_level(level: int) -> void:
	var level_str = str(level)
	var level_data: Dictionary = level_chart.get(level_str) as Dictionary
	var st: int = level_data.get("Strength") as int
	var ag: int = level_data.get("Agility") as int
	var hp: int = level_data.get("HP") as int
	var mp: int = level_data.get("MP") as int
	process_stats_from_growth(st, ag, hp, mp)


func process_growth_value() -> void:
	var sum: int = 0
	for n in range(4):
		sum += letter_values.get(hero_name[n]) as int
	growth_value = sum % 4
	growth_sum = sum


func process_stats_from_growth(st: int, ag: int, hp: int, mp: int) -> void:
	match growth_value:
		0:
			stats.set_max_hp(hp)
			stats.set_max_mp(mp)
			stats.set_strength(get_short_stat_value(st))
			stats.set_agility(get_short_stat_value(ag))
		1:
			stats.set_max_hp(hp)
			stats.set_max_mp(get_short_stat_value(mp))
			stats.set_strength(st)
			stats.set_agility(get_short_stat_value(ag))
		2:
			stats.set_max_hp(get_short_stat_value(hp))
			stats.set_max_mp(mp)
			stats.set_strength(get_short_stat_value(st))
			stats.set_agility(ag)
		3:
			stats.set_max_hp(get_short_stat_value(hp))
			stats.set_max_mp(get_short_stat_value(mp))
			stats.set_strength(st)
			stats.set_agility(ag)


func get_short_stat_value(orig: int) -> int:
	var round_down: int = floor(float(growth_sum) / 4.0)
	var rem: int = round_down % 4
	return rem + int(orig * 9 / 10.0)
