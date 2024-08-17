extends DialogueEvent
class_name ChangeHeroStatsDialogueEvent

enum OperationKey {
	MAX_OUT_MP,
	HEAL_HP
}

@export var key: OperationKey
@export var min_val: int
@export var max_val: int

func execute(window: DialogueWindow, _params: Dictionary) -> void:
	await window.get_tree().process_frame
	match key:
		OperationKey.MAX_OUT_MP:
			var max_mp: int = PlayerManager.hero.stats.get_base(UnitStats.StatKey.MP)
			PlayerManager.hero.stats.set_stat(UnitStats.StatKey.MP, max_mp)
		OperationKey.HEAL_HP:
			PlayerManager.hero.stats.modify_stat(UnitStats.StatKey.HP, randi_range(min_val, max_val))
