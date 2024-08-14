extends DialogueEvent
class_name ChangeHeroStatsDialogueEvent

enum OperationKey {
	MAX_OUT_MP
}

@export var key: OperationKey
@export var amount: int

func execute(window: DialogueWindow, _params: Dictionary) -> void:
	await window.get_tree().process_frame
	match key:
		OperationKey.MAX_OUT_MP:
			var max_mp: int = PlayerManager.hero.stats.get_base(UnitStats.StatKey.MP)
			PlayerManager.hero.stats.set_stat(UnitStats.StatKey.MP, max_mp)
