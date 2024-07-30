extends BattleUpdate
class_name DefeatBattleUpdate

func execute(controller: BattleController) -> void:
	await controller.battle_ui.show_line(
		GeneralDialogueProvider.DialogueID.Newline
	)
	await controller.get_tree().create_timer(3).timeout
	await controller.battle_ui.show_line(
		GeneralDialogueProvider.DialogueID.BattlePlayerDeath
	)
	await controller.battle_ui.show_newline()
	finish(controller)
