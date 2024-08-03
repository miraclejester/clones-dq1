extends BattleUnit
class_name HeroUnit

signal hp_changed(new_val: int)
signal mp_changed(new_val: int)
signal level_changed(new_val: int)
signal gold_changed(new_val: int)
signal exp_changed(new_val: int)

@export_file var level_chart_path: String
@export_file var letter_values_path: String

var level_chart: Dictionary
var letter_values: Dictionary
var growth_value: int
var growth_sum: int
var hero_name: String

var level: int = 1
var gold: int = 0
var experience: int = 0


func _ready() -> void:
	level_chart = FileUtils.load_json_dict(level_chart_path)
	letter_values = FileUtils.load_json_dict(letter_values_path)
	crit_chance = 1.0 / 32.0
	
	stats.hp_changed.connect(on_hp_changed)
	stats.mp_changed.connect(on_mp_changed)


func process_turn(battle: Battle) -> void:
	battle.updates.append(HeroCommandBattleUpdate.new())


func get_deal_damage_update(damage: int, new_hp: int) -> BattleUpdate:
	return PlayerHurtBattleUpdate.new(self, damage, new_hp)


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


func set_stats_from_level(l: int) -> void:
	set_level(l)
	var level_str = str(l)
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
	if orig == 0:
		return orig
	var round_down: int = floor(float(growth_sum) / 4.0)
	var rem: int = round_down % 4
	return rem + int(orig * 9 / 10.0)


func set_hp(val: int) -> void:
	stats.hp = val


func set_mp(val: int) -> void:
	stats.mp = val


func on_hp_changed(val: int) -> void:
	hp_changed.emit(val)


func on_mp_changed(val: int) -> void:
	mp_changed.emit(val)


func level_up() -> void:
	level += 1
	set_stats_from_level(level)
	level_changed.emit(level)


func set_level(l: int) -> void:
	level = l
	level_changed.emit(level)


func add_gold(val: int) -> void:
	gold = clampi(gold + val, 0, 9999)
	gold_changed.emit(gold)


func add_exp(val: int) -> void:
	experience += val
	exp_changed.emit(experience)


func get_unit_name() -> String:
	return hero_name
