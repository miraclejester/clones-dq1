extends BattleUpdate
class_name EnemyRunBattleUpdate

var enemy: EnemyUnit

func _init(e: EnemyUnit) -> void:
	enemy = e


func execute(controller: BattleController) -> void:
	await controller.battle_ui.show_line(
		GeneralDialogueProvider.DialogueID.BattleEnemyRun,
		[enemy.get_unit_name()]
	)
	await controller.battle_ui.show_newline()
