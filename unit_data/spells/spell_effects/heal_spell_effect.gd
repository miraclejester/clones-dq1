extends SpellEffect
class_name HealSpellEffect

@export var min_heal: int
@export var max_heal: int
@export var heal_dialogue: DialogueEvent

func execute_battle(_battle: Battle, user: BattleUnit, target: BattleUnit) -> Array[BattleUpdate]:
	var res: Array[BattleUpdate] = []
	var heal: int = randi_range(min_heal, max_heal)
	target.deal_damage(-heal)
	if heal_dialogue != null:
		res.append(PlayDialogueBattleUpdate.new(heal_dialogue, [user.get_unit_name()], false))
	res.append(UpdateHUDBattleUpdate.new(PlayerHUD.HUDStatKey.HP, target.stats.get_stat(UnitStats.StatKey.HP), user))
	return res
