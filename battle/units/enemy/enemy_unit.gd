extends BattleUnit
class_name EnemyUnit

var data: EnemyData

func set_data(d: EnemyData) -> void:
	set_stats_from_data(d)


func process_turn(battle: Battle) -> void:
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


func get_deal_damage_update(damage: int, _new_hp: int) -> BattleUpdate:
	return EnemyHurtBattleUpdate.new(get_unit_name(), damage)


func get_sleep_started_format_vars() -> Array:
	return [get_unit_name()]


func get_sleep_continues_format_vars() -> Array:
	return [get_unit_name()]


func hurt_hit_check() -> bool:
	var roll: float = randf_range(0.0, 1.0)
	return roll < (1.0 - data.stats.hurt_resist)
	

func sleep_hit_check() -> bool:
	var roll: float = randf_range(0.0, 1.0)
	return roll < (1.0 - data.stats.sleep_resist)


func stopspell_hit_check() -> bool:
	return randf_range(0.0, 1.0) < (1.0 - data.stats.stop_spell_resist)


func sleep_wake_check(turns: int) -> bool:
	return turns > 1 and randf_range(0.0, 1.0) < 0.33


func set_stats_from_data(ed: EnemyData) -> void:
	data = ed
	stats.set_strength(ed.stats.strength)
	stats.set_agility(ed.stats.agility)
	stats.set_max_hp(randi_range(ed.stats.min_hp, ed.stats.max_hp))
	stats.set_max_mp(0)
	stats.hp = stats.max_hp
	stats.mp = stats.max_mp


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


func get_unit_name() -> String:
	return data.enemy_name


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
