extends BattleUpdate
class_name LevelUpBattleUpdate

var result: LevelUpResult

func _init(r: LevelUpResult) -> void:
	result = r


func execute(controller: BattleController) -> void:
	await controller.get_tree().create_timer(2).timeout
	await controller.battle_ui.show_newline()
	await controller.battle_ui.show_line(GeneralDialogueProvider.DialogueID.CourageWit)
	await controller.battle_ui.show_line(
		GeneralDialogueProvider.DialogueID.PromotedLevel
	)
	await controller.battle_ui.show_newline()
	await stat_increase_dialogue(controller, "Power", result.strength_gain, true)
	await stat_increase_dialogue(controller, "Response Speed", result.agility_gain, true)
	await stat_increase_dialogue(controller, "Maximum Hit Points", result.hp_gain, false)
	await stat_increase_dialogue(controller, "Maximum Magic Points", result.mp_gain, false)
	if result.spell_learned:
		await controller.battle_ui.show_line(GeneralDialogueProvider.DialogueID.NewSpell)
		await controller.battle_ui.show_newline()


func stat_increase_dialogue(controller: BattleController, stat_name: String, value: int, is_plural: bool) -> void:
	var plural_add: String = "s" if is_plural else ""
	if value > 0:
		await controller.battle_ui.show_line(
			GeneralDialogueProvider.DialogueID.StatIncrease,
			[stat_name, plural_add, value]
		)
		await controller.battle_ui.show_newline()
