extends SpellEffect
class_name SleepSpellEffect

func execute_battle(_battle: Battle, _user: BattleUnit, target: BattleUnit) -> Array[BattleUpdate]:
	var res: Array[BattleUpdate] = []
	var sleep_hits: bool = target.resistance_hit_check(UnitStats.ResistanceKey.SLEEP)
	if sleep_hits:
		target.add_status(BattleUnit.StatusEffect.SLEEP)
		res.append(SleepBattleUpdate.new(target, false, true))
	else:
		res.append(SpellFailBattleUpdate.new())
	return res
