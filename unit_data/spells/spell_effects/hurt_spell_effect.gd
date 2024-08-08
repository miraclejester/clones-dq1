extends SpellEffect
class_name HurtSpellEffect

@export var damage_deal_effect: DealDamageSpellEffect

func execute_battle(battle: Battle, user: BattleUnit, target: BattleUnit) -> Array[BattleUpdate]:
	var res: Array[BattleUpdate] = []
	var hits: bool = target.resistance_hit_check(UnitStats.ResistanceKey.HURT)
	if hits:
		res.append_array(damage_deal_effect.execute_battle(battle, user, target))
	else:
		res.append(SpellFailBattleUpdate.new())
	return res
