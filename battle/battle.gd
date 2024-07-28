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

func init_battle(hero_state: HeroState, e: EnemyData) -> void:
	hero.set_hero_name(hero_state.hero_name)
	hero.set_stats_from_level(hero_state.level)
	hero.set_hp(hero_state.hp)
	hero.set_mp(hero_state.mp)
	enemy.set_data(e)
	roll_initiative()


func start_battle() -> Array[BattleUpdate]:
	var unit: BattleUnit = turn_order[turn_index]
	turn_index = (turn_index + 1) % 2
	var res: Array[BattleUpdate] = []
	if unit is HeroUnit:
		res.append(HeroCommandBattleUpdate.new())
	else:
		res.append(fight_action(enemy, hero))
		res.append_array(check_battle_end())
		if not is_battle_finished():
			res.append(HeroCommandBattleUpdate.new())
	return res


func player_fight() -> Array[BattleUpdate]:
	var res: Array[BattleUpdate] = []
	res.append(fight_action(hero, enemy))
	res.append_array(check_battle_end())
	
	if not is_battle_finished():
		res.append(fight_action(enemy, hero))
		res.append_array(check_battle_end())
	
	if not is_battle_finished():
		res.append(HeroCommandBattleUpdate.new())
	return res


func check_battle_end() -> Array[BattleUpdate]:
	var res: Array[BattleUpdate] = []
	if enemy.is_dead():
		var exp_gain: int = enemy.get_xp()
		var gold_gain: int = enemy.get_gp()
		hero.add_exp(exp_gain)
		hero.add_gold(gold_gain)
		res.append(VictoryBattleUpdate.from_data(enemy.get_unit_name(), exp_gain, gold_gain))
	return res


func is_battle_finished() -> bool:
	return hero.is_dead() or enemy.is_dead()


func fight_action(attacker: BattleUnit, defender: BattleUnit) -> BattleUpdate:
	var dodge_roll: float = randf_range(0, 1)
	if dodge_roll < defender.get_dodge():
		return AttackBattleUpdate.fromData(
			AttackBattleUpdate.AttackResult.DODGE, attacker, defender, 0
		)
		
	var crit_roll: float = randf_range(0, 1)
	if crit_roll < attacker.crit_chance:
		var d: int = attacker.get_crit_damage()
		defender.deal_damage(d)
		return AttackBattleUpdate.fromData(
			AttackBattleUpdate.AttackResult.CRIT, attacker, defender, d
		)
	
	var dmg: int = attacker.get_attack_damage(defender)
	defender.deal_damage(dmg)
	
	if dmg < 1:
		return AttackBattleUpdate.fromData(
			AttackBattleUpdate.AttackResult.DODGE, attacker, defender, 0
		)
	return AttackBattleUpdate.fromData(
		AttackBattleUpdate.AttackResult.HIT, attacker, defender, dmg
	)


func roll_initiative() -> void:
	var hero_roll: int = hero.stats.agility * randi_range(0, 255)
	var enemy_roll: int = floor(enemy.stats.agility * randi_range(0, 255) * enemy.get_group_factor())
	if hero_roll < enemy_roll:
		turn_order = [enemy, hero]
	else:
		turn_order = [hero, enemy]
