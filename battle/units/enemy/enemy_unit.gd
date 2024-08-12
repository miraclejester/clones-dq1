extends BattleUnit
class_name EnemyUnit

var data: EnemyData

func set_data(d: EnemyData) -> void:
	set_stats_from_data(d)


func process_turn(battle: Battle) -> void:
	if battle.enemy_run_check():
		return
	process_patterns(battle)
	battle.next_turn()


func process_patterns(battle: Battle) -> void:
	for pattern_entry in data.patterns:
		if pattern_entry.roll(self, battle.hero):
			if pattern_entry.action is SpellData:
				battle.spell_action(
					pattern_entry.action as SpellData,
					self,
					pattern_entry.action.get_target(self, battle.hero)
				)
			elif pattern_entry.action is AbilityData:
				battle.ability_action(
					pattern_entry.action as AbilityData,
					self,
					pattern_entry.action.get_target(self, battle.hero)
				)
			return
	battle.fight_action(self, battle.hero)


func is_running_away(hero: HeroUnit) -> bool:
	var hero_str: int = hero.stats.get_stat(UnitStats.StatKey.STR)
	var e_str: int = stats.get_stat(UnitStats.StatKey.STR)
	return (hero_str >= e_str * 2) and (randf_range(0.0, 1.0) < 0.25)


func get_deal_damage_update(damage: int, _new_hp: int) -> BattleUpdate:
	return EnemyHurtBattleUpdate.new(get_unit_name(), damage)


func get_sleep_started_format_vars() -> Array:
	return [get_unit_name()]


func get_sleep_continues_format_vars() -> Array:
	return [get_unit_name()]


func get_resistance_modifier(_key: UnitStats.ResistanceKey) -> float:
	return 1.0


func sleep_wake_check(turns: int) -> bool:
	return turns > 1 and randf_range(0.0, 1.0) < 0.33


func set_stats_from_data(ed: EnemyData) -> void:
	data = ed
	stats.set_base(UnitStats.StatKey.STR, ed.stats.strength)
	stats.set_base(UnitStats.StatKey.AGI, ed.stats.agility)
	stats.set_base(UnitStats.StatKey.HP, randi_range(ed.stats.min_hp, ed.stats.max_hp))
	stats.set_base(UnitStats.StatKey.MP, 0)
	stats.set_base_resistance(UnitStats.ResistanceKey.SLEEP, ed.stats.sleep_resist)
	stats.set_base_resistance(UnitStats.ResistanceKey.STOPSPELL, ed.stats.stop_spell_resist)
	stats.set_base_resistance(UnitStats.ResistanceKey.HURT, ed.stats.hurt_resist)


func get_attack_damage(defender: BattleUnit) -> int:
	var st: int = stats.get_stat(UnitStats.StatKey.STR)
	if defender.get_defense() >= st:
		return randi_range(0, floor((st + 4) / 6.0))
	return super(defender)


func get_dodge() -> float:
	return data.stats.dodge


func get_xp() -> int:
	return data.stats.xp


func get_gp() -> int:
	return randi_range(data.stats.min_gp, data.stats.max_gp)


func get_unit_name() -> String:
	return data.enemy_name


func get_attack_sfx_key() -> String:
	return "enemy_attack"


func play_spell_effect() -> void:
	await GlobalVisuals.enemy_spell_effect()


func get_group_factor() -> float:
	match data.initiative_group:
		0:
			return 0.25
		1:
			return 0.375
		2:
			return 0.5
		3, _:
			return 1
