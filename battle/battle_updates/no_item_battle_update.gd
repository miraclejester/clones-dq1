extends BattleUpdate
class_name NoItemBattleUpdate

func execute(controller: BattleController)  -> void:
	await controller.battle_ui.show_line(GeneralDialogueProvider.DialogueID.FieldNoItems)
	await controller.battle_ui.show_newline()
