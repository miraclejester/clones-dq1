extends BattleUnit
class_name HeroUnit

signal hp_changed(new_val: int)
signal mp_changed(new_val: int)
signal level_changed(new_val: int)
signal gold_changed(new_val: int)
signal exp_changed(new_val: int)
signal item_equipped(eq: EquipmentData)
signal princess_status_changed(rescuing: bool)

@export_file var level_chart_path: String
@export_file var letter_values_path: String

var level_chart: Dictionary
var letter_values: Dictionary
var growth_value: int
var growth_sum: int
var hero_name: String
var inventory: HeroInventory
var equipment: HeroEquipment

var level: int = 1
var gold: int = 0
var experience: int = 0
var is_cursed: bool = false
var step_counter: int = 0
var rescuing_princess: bool = false


func _ready() -> void:
	level_chart = FileUtils.load_json_dict(level_chart_path)
	letter_values = FileUtils.load_json_dict(letter_values_path)
	crit_chance = 1.0 / 32.0
	inventory = HeroInventory.new()
	equipment = HeroEquipment.new()
	
	stats.set_base_resistance(UnitStats.ResistanceKey.SLEEP, 0.0)
	stats.set_base_resistance(UnitStats.ResistanceKey.STOPSPELL, 0.5)
	stats.set_base_resistance(UnitStats.ResistanceKey.HURT, 0.0)
	
	stats.hp_changed.connect(on_hp_changed)
	stats.mp_changed.connect(on_mp_changed)
	
	equipment.item_equipped.connect(func (eq: EquipmentData): item_equipped.emit(eq))


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


func get_damage_multiplier(key: UnitStats.DamageType) -> float:
	return equipment.get_damage_multiplier(key)


func get_attack() -> int:
	return stats.get_stat(UnitStats.StatKey.STR) + equipment.get_attack_power()


func get_defense() -> int:
	return floor(stats.get_stat(UnitStats.StatKey.AGI) / 2.0) + equipment.get_defense_power()


func get_resistance_modifier(key: UnitStats.ResistanceKey) -> float:
	return equipment.get_resistance_multiplier(key)


func get_base_resistance(key: UnitStats.ResistanceKey) -> float:
	var eq_base: float = equipment.get_base_resistance(key)
	if eq_base != -1.0:
		return eq_base
	return stats.get_base_resistance(key) 


func set_hero_name(new_name: String) -> void:
	hero_name = new_name
	process_growth_value()


func set_stats_from_level(l: int, go_max: bool = false) -> void:
	set_level(l)
	var level_str = str(l)
	var level_data: Dictionary = level_chart.get(level_str) as Dictionary
	var st: int = level_data.get("Strength") as int
	var ag: int = level_data.get("Agility") as int
	var hp: int = level_data.get("HP") as int
	var mp: int = level_data.get("MP") as int
	process_stats_from_growth(st, ag, hp, mp, go_max)


func process_growth_value() -> void:
	var sum: int = 0
	for n in range(4):
		var letter: String = " "
		if hero_name.length() > n:
			letter = hero_name[n]
		sum += letter_values.get(letter, 0) as int
	growth_value = sum % 4
	growth_sum = sum


func process_stats_from_growth(st: int, ag: int, hp: int, mp: int, go_max: bool) -> void:
	match growth_value:
		0:
			stats.set_base(UnitStats.StatKey.HP, hp, go_max)
			stats.set_base(UnitStats.StatKey.MP, mp, go_max)
			stats.set_base(UnitStats.StatKey.STR, get_short_stat_value(st))
			stats.set_base(UnitStats.StatKey.AGI, get_short_stat_value(ag))
		1:
			stats.set_base(UnitStats.StatKey.HP, hp, go_max)
			stats.set_base(UnitStats.StatKey.MP, get_short_stat_value(mp), go_max)
			stats.set_base(UnitStats.StatKey.STR, st)
			stats.set_base(UnitStats.StatKey.AGI, get_short_stat_value(ag))
		2:
			stats.set_base(UnitStats.StatKey.HP, get_short_stat_value(hp), go_max)
			stats.set_base(UnitStats.StatKey.MP, mp, go_max)
			stats.set_base(UnitStats.StatKey.STR, get_short_stat_value(st))
			stats.set_base(UnitStats.StatKey.AGI, ag)
		3:
			stats.set_base(UnitStats.StatKey.HP, get_short_stat_value(hp), go_max)
			stats.set_base(UnitStats.StatKey.MP, get_short_stat_value(mp), go_max)
			stats.set_base(UnitStats.StatKey.STR, st)
			stats.set_base(UnitStats.StatKey.AGI, ag)


func get_short_stat_value(orig: int) -> int:
	if orig == 0:
		return orig
	var round_down: int = floor(float(growth_sum) / 4.0)
	var rem: int = round_down % 4
	return rem + int(orig * 9 / 10.0)



func on_hp_changed(val: int) -> void:
	hp_changed.emit(val)


func on_mp_changed(val: int) -> void:
	mp_changed.emit(val)


func level_up() -> LevelUpResult:
	var res: LevelUpResult = LevelUpResult.new()
	var old_strength: int = stats.get_base(UnitStats.StatKey.STR)
	var old_agility: int = stats.get_base(UnitStats.StatKey.AGI)
	var old_max_hp: int = stats.get_base(UnitStats.StatKey.HP)
	var old_max_mp: int = stats.get_base(UnitStats.StatKey.MP)
	var spell: SpellData = PlayerManager.get_next_level_entry().learned_spell
	set_stats_from_level(level + 1, false)
	if spell != null:
		spells.append(spell)
	
	res.strength_gain = stats.get_base(UnitStats.StatKey.STR) - old_strength
	res.agility_gain = stats.get_base(UnitStats.StatKey.AGI) - old_agility
	res.hp_gain = stats.get_base(UnitStats.StatKey.HP) - old_max_hp
	res.mp_gain = stats.get_base(UnitStats.StatKey.MP) - old_max_mp
	res.spell_learned = spell != null
	return res


func has_leveled_up() -> bool:
	if level >= 30:
		return false
	var entry: ExperienceChartEntry = PlayerManager.get_next_level_entry()
	return experience >= entry.experience


func set_level(l: int) -> void:
	level = l
	level_changed.emit(level)


func add_exp(val: int, immediate_level_up: bool = false) -> void:
	experience = clampi(experience + val, 0, 65535)
	exp_changed.emit(experience)
	if immediate_level_up and has_leveled_up():
		level_up()


func add_gold(val: int) -> void:
	gold = clampi(gold + val, 0, 99999)
	gold_changed.emit(gold)


func spend_gold(val: int) -> void:
	gold = clampi(gold - val, 0, 99999)
	gold_changed.emit(gold)


func get_unit_name() -> String:
	return hero_name


func on_step() -> void:
	step_counter += 1
	equipment.on_step(step_counter)
	if step_counter >= 256:
		step_counter = 0


func on_map_transition() -> void:
	step_counter = 0


func change_princess_status(rescuing: bool) -> void:
	rescuing_princess = rescuing
	princess_status_changed.emit(rescuing)
