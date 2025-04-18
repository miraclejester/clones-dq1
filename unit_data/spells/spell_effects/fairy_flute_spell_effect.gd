extends SpellEffect
class_name FairyFluteSpellEffect

@export var target_enemy_name: String = "Golem"
@export var success_dialogue: DialogueEvent
@export var failure_dialogue: DialogueEvent

func execute_battle(_battle: Battle, _user: BattleUnit, target: BattleUnit) -> Array[BattleUpdate]:
	var res: Array[BattleUpdate] = []
	res.append(PlayOneShotBGMBattleUpdate.new("fairy_flute"))
	if target.get_unit_name() != target_enemy_name:
		res.append(PlayDialogueBattleUpdate.new(failure_dialogue, [], false))
	else:
		target.add_status(BattleUnit.StatusEffect.SLEEP)
		res.append(PlayDialogueBattleUpdate.new(success_dialogue, [], false))
	return res
