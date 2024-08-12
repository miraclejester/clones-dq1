extends BattleUpdate
class_name DefeatBattleUpdate

func execute(controller: BattleController) -> void:
	await AudioManager.play_bgm_one_shot("defeat")
	await controller.battle_ui.show_line(
		GeneralDialogueProvider.DialogueID.BattlePlayerDeath
	)
	await controller.battle_ui.show_newline()
