extends BattleUpdate
class_name EnemyRunBattleUpdate

var enemy: EnemyUnit

func _init(e: EnemyUnit) -> void:
	enemy = e


func execute(controller: BattleController) -> void:
	controller.enemy_controller.visible = false
	AudioManager.play_sfx(SFXEntry.SFXKey.Run)
	await controller.battle_ui.show_line(
		GeneralDialogueProvider.DialogueID.BattleEnemyRun,
		[enemy.get_unit_name()]
	)
	await controller.battle_ui.show_newline()
