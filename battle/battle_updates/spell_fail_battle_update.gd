extends BattleUpdate
class_name SpellFailBattleUpdate

func execute(controller: BattleController) -> void:
	await controller.battle_ui.show_line(GeneralDialogueProvider.DialogueID.BattleSpellWillNotWork)
