extends SpellEffect
class_name HealSpellEffect

@export var min_heal: int
@export var max_heal: int

func execute_battle(_battle: Battle, user: BattleUnit, target: BattleUnit) -> Array[BattleUpdate]:
	var res: Array[BattleUpdate] = []
	var heal: int = randi_range(min_heal, max_heal)
	target.deal_damage(-heal)
	res.append(UpdateHUDBattleUpdate.new(PlayerHUD.HUDStatKey.HP, target.stats.hp, user))
	return res
