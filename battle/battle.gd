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


func next_turn() -> Array[BattleUpdate]:
	var unit: BattleUnit = turn_order[turn_index]
	turn_index = (turn_index + 1) % 2
	var res: Array[BattleUpdate] = []
	if unit is HeroUnit:
		res.append(HeroCommandBattleUpdate.new())
	else:
		res.append(fight_action(enemy, hero))
		res.append_array(next_turn())
	return res


func fight_action(attacker: BattleUnit, defender: BattleUnit) -> BattleUpdate:
	var dodge_roll: float = randf_range(0, 1)
	if dodge_roll < defender.get_dodge():
		return AttackBattleUpdate.fromData(
			AttackBattleUpdate.AttackResult.DODGE, attacker, defender, 0
		)
		
	var crit_roll: float = randf_range(0, 1)
	if crit_roll < attacker.crit_chance:
		return AttackBattleUpdate.fromData(
			AttackBattleUpdate.AttackResult.CRIT, attacker, defender, attacker.get_crit_damage()
		)
		
	return AttackBattleUpdate.fromData(
		AttackBattleUpdate.AttackResult.HIT, attacker, defender, attacker.get_attack_damage(defender)
	)


func roll_initiative() -> void:
	var hero_roll: int = hero.stats.agility * randi_range(0, 255)
	var enemy_roll: int = floor(enemy.stats.agility * randi_range(0, 255) * enemy.get_group_factor())
	if hero_roll < enemy_roll:
		turn_order = [enemy, hero]
	else:
		turn_order = [hero, enemy]
