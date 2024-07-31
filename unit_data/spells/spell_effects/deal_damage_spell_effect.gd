extends SpellEffect
class_name DealDamageSpellEffect

@export var min_damage: int
@export var max_damage: int

func execute(battle: Battle, user: BattleUnit, target: BattleUnit) -> Array[BattleUpdate]:
	var res: Array[BattleUpdate] = []
	var damage: int = randi_range(min_damage, max_damage)
	target.deal_damage(damage)
	res.append(target.get_deal_damage_update(damage))
	return res
