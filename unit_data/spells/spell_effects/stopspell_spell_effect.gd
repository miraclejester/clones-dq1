extends SpellEffect
class_name StopSpellSpellEffect

func execute_battle(_battle: Battle, _user: BattleUnit, target: BattleUnit) -> Array[BattleUpdate]:
	var res: Array[BattleUpdate] = []
	var hits: bool = target.stopspell_hit_check()
	if hits:
		target.add_status(BattleUnit.StatusEffect.STOPSPELL)
		res.append(StopSpellBattleUpdate.new(target, true))
	else:
		res.append(SpellFailBattleUpdate.new())
	return res
