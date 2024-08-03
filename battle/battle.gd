extends Node
class_name Battle

@export var hero_scene: PackedScene
@export var enemy_scene: PackedScene

enum BattleState {
	HERO_TURN,
	ENEMY_TURN
}

@onready var hero: HeroUnit = $Hero
@onready var enemy: EnemyUnit = $Enemy

var turn_order: Array[BattleUnit] = []
var turn_index: int = 0
var updates: Array[BattleUpdate]


func init_battle(hero_state: HeroState, e: EnemyData) -> void:
	hero.set_hero_name(hero_state.hero_name)
	hero.set_stats_from_level(hero_state.level)
	hero.set_hp(hero_state.hp)
	hero.set_mp(hero_state.mp)
	hero.spells = DebugUtils.debug_spells
	enemy.set_data(e)
	updates = []
	
	hero.clear_status()
	enemy.clear_status()
	
	roll_initiative()


func start_battle() -> void:
	if turn_order[0] is EnemyUnit:
		updates.append(EnemyFirstBattleUpdate.from_data(enemy.get_unit_name(), hero.get_unit_name()))
	do_turn()


func flush_updates() -> Array[BattleUpdate]:
	var res: Array[BattleUpdate] = []
	res.assign(updates)
	updates = []
	return res


func next_turn() -> void:
	turn_index = (turn_index + 1) % 2
	do_turn()


func do_turn() -> void:
	var unit: BattleUnit = turn_order[turn_index]
	check_battle_end()
	if not is_battle_finished():
		if unit.has_status(BattleUnit.StatusEffect.SLEEP):
			unit.sleep_turns += 1
			if unit.sleep_wake_check(unit.sleep_turns):
				unit.sleep_turns = 0
				unit.remove_status(BattleUnit.StatusEffect.SLEEP)
				updates.append(SleepBattleUpdate.new(unit, false))
				unit.process_turn(self)
			else:
				updates.append(SleepBattleUpdate.new(unit, false))
				next_turn()
			return
		unit.process_turn(self)


func player_fight() -> void:
	fight_action(hero, enemy)
	next_turn()


func player_run() -> void:
	if enemy.has_status(BattleUnit.StatusEffect.SLEEP) or speed_roll():
		updates.append(RunBattleUpdate.from_data(hero.get_unit_name(), RunBattleUpdate.RunResult.SUCCESS))
		updates.append(FinishBattleUpdate.new())
	else:
		updates.append(RunBattleUpdate.from_data(hero.get_unit_name(), RunBattleUpdate.RunResult.FAILURE))
		next_turn()


func player_spell(spell: SpellData) -> void:
	var target: BattleUnit
	match spell.target_type:
		SpellData.TargetType.SELF:
			target = hero
		SpellData.TargetType.ENEMY:
			target = enemy
	spell_action(spell, hero, target)
	next_turn()


func check_battle_end() -> void:
	if enemy.is_dead():
		var exp_gain: int = enemy.get_xp()
		var gold_gain: int = enemy.get_gp()
		hero.add_exp(exp_gain)
		hero.add_gold(gold_gain)
		updates.append(VictoryBattleUpdate.from_data(enemy.get_unit_name(), exp_gain, gold_gain))
		updates.append(FinishBattleUpdate.new())
	elif hero.is_dead():
		updates.append(DefeatBattleUpdate.new())
		updates.append(FinishBattleUpdate.new())


func is_battle_finished() -> bool:
	return hero.is_dead() or enemy.is_dead()


func fight_action(attacker: BattleUnit, defender: BattleUnit) -> void:
	var dodge_roll: float = randf_range(0, 1)
	if dodge_roll < defender.get_dodge():
		updates.append(AttackBattleUpdate.fromData(
			AttackBattleUpdate.AttackResult.DODGE, attacker, defender, 0, defender.stats.hp
		))
		return
		
	var crit_roll: float = randf_range(0, 1)
	if crit_roll < attacker.crit_chance:
		var d: int = attacker.get_crit_damage()
		defender.deal_damage(d)
		updates.append(AttackBattleUpdate.fromData(
			AttackBattleUpdate.AttackResult.CRIT, attacker, defender, d, defender.stats.hp
		))
		return
	
	var dmg: int = attacker.get_attack_damage(defender)
	defender.deal_damage(dmg)
	
	if dmg < 1:
		updates.append(AttackBattleUpdate.fromData(
			AttackBattleUpdate.AttackResult.NO_DAMAGE, attacker, defender, 0, defender.stats.hp
		))
		return
	updates.append(AttackBattleUpdate.fromData(
		AttackBattleUpdate.AttackResult.HIT, attacker, defender, dmg, defender.stats.hp
	))


func spell_action(spell: SpellData, user: BattleUnit, target: BattleUnit) -> void:
	var spell_updates: Array[BattleUpdate] = []
	user.stats.mp -= spell.mp_cost
	if user.has_status(BattleUnit.StatusEffect.STOPSPELL):
		spell_updates.append(StopSpellBattleUpdate.new(target, false))
	else:
		for effect in spell.spell_effects:
			spell_updates.append_array(effect.execute_battle(self, user, target))
	updates.append(SpellBattleUpdate.new(spell, user, target, spell_updates, user.stats.mp))


func roll_initiative() -> void:
	if speed_roll():
		turn_order = [hero, enemy]
	else:
		turn_order = [enemy, hero]


func speed_roll() -> bool:
	var hero_roll: int = hero.stats.agility * randi_range(0, 255)
	var enemy_roll: int = floor(enemy.stats.agility * randi_range(0, 255) * enemy.get_group_factor())
	return enemy_roll <= hero_roll
