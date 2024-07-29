extends BattleUpdate
class_name DefeatBattleUpdate

func execute(controller: BattleController) -> void:
	await controller.battle_ui.show_battle_paragraph(
		GeneralDialogueProvider.DialogueID.Newline, [], true
	)
	await controller.get_tree().create_timer(3).timeout
	await controller.battle_ui.show_battle_paragraph(
		GeneralDialogueProvider.DialogueID.BattlePlayerDeath, [], true
	)
	await controller.battle_ui.show_battle_paragraph(
		GeneralDialogueProvider.DialogueID.Newline, [], true
	)
	finish(controller)
