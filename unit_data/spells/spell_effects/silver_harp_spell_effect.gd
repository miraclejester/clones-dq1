extends SpellEffect
class_name SilverHarpSpellEffect

@export var enemy_react_dialogue: DialogueEvent

func execute_battle(_battle: Battle, _user: BattleUnit, target: BattleUnit) -> Array[BattleUpdate]:
	var res: Array[BattleUpdate] = []
	res.append(PlayOneShotBGMBattleUpdate.new(BGMEntry.BGMKey.SilverHarp))
	res.append(PlayDialogueBattleUpdate.new(enemy_react_dialogue, [target.get_unit_name()], false))
	return res
