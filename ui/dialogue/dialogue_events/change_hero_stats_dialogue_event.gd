extends DialogueEvent
class_name ChangeHeroStatsDialogueEvent

enum OperationKey {
	MAX_OUT_MP,
	HEAL_HP,
	ADD_DEFENSE_MODIFIER,
	EQUIP_ACCESSORY,
	FULL_HEAL,
	MODIFY_MP,
	ADD_CURSE,
	REMOVE_CURSE,
	ADD_PRINCESS,
	REMOVE_PRINCESS,
	SET_TILE_DAMAGE_MULTIPLIER
}

@export var key: OperationKey
@export var min_val: int
@export var max_val: int
@export var id: int
@export var float_val: float

func execute(window: DialogueWindow, _params: Dictionary) -> void:
	await window.get_tree().process_frame
	match key:
		OperationKey.MAX_OUT_MP:
			var max_mp: int = PlayerManager.hero.stats.get_base(UnitStats.StatKey.MP)
			PlayerManager.hero.stats.set_stat(UnitStats.StatKey.MP, max_mp)
		OperationKey.HEAL_HP:
			PlayerManager.hero.stats.modify_stat(UnitStats.StatKey.HP, randi_range(min_val, max_val))
		OperationKey.ADD_DEFENSE_MODIFIER:
			PlayerManager.hero.equipment.permanent_defense_modifier += min_val
		OperationKey.EQUIP_ACCESSORY:
			PlayerManager.hero.equipment.equip_accessory(id)
		OperationKey.FULL_HEAL:
			PlayerManager.hero.stats.maximize(UnitStats.StatKey.HP)
			PlayerManager.hero.stats.maximize(UnitStats.StatKey.MP)
		OperationKey.MODIFY_MP:
			PlayerManager.hero.stats.modify_stat(UnitStats.StatKey.MP, min_val)
		OperationKey.ADD_CURSE:
			PlayerManager.hero.is_cursed = true
		OperationKey.REMOVE_CURSE:
			PlayerManager.hero.is_cursed = false
		OperationKey.ADD_PRINCESS:
			PlayerManager.hero.change_princess_status(true)
		OperationKey.REMOVE_PRINCESS:
			PlayerManager.hero.change_princess_status(false)
		OperationKey.SET_TILE_DAMAGE_MULTIPLIER:
			PlayerManager.hero.equipment.tile_damage_multiplier = float_val
