extends SpellEffect
class_name DealDamageSpellEffect

@export var min_damage: int
@export var max_damage: int


func execute_battle(_battle: Battle, _user: BattleUnit, target: BattleUnit) -> Array[BattleUpdate]:
	var res: Array[BattleUpdate] = []
	var damage: int = randi_range(min_damage, max_damage)
	target.deal_damage(damage)
	res.append(target.get_deal_damage_update(damage, target.stats.get_stat(UnitStats.StatKey.HP)))
	return res
