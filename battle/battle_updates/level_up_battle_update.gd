extends BattleUpdate
class_name LevelUpBattleUpdate

var result: LevelUpResult
var dialogue_callables: Array[Callable]

func _init(r: LevelUpResult) -> void:
	result = r
	dialogue_callables = []


func execute(controller: BattleController) -> void:
	await AudioManager.play_bgm_one_shot(BGMEntry.BGMKey.LevelUp)
	AudioManager.play_bgm(BGMEntry.BGMKey.Overworld)
	await controller.battle_ui.wait_for_dialogue_continuation()
	await controller.battle_ui.show_line(GeneralDialogueProvider.DialogueID.CourageWit)
	await controller.battle_ui.show_line(
		GeneralDialogueProvider.DialogueID.PromotedLevel
	)
	await controller.battle_ui.wait_for_dialogue_continuation()
	
	
	check_stat_increase(controller, "Power", result.strength_gain, true)
	check_stat_increase(controller, "Response Speed", result.agility_gain, true)
	check_stat_increase(controller, "Maximum Hit Points", result.hp_gain, false)
	check_stat_increase(controller, "Maximum Magic Points", result.mp_gain, false)
	if result.spell_learned:
		dialogue_callables.append(spell_learned_dialogue.bind(controller))
	
	for i in range(dialogue_callables.size()):
		await dialogue_callables[i].call()
		if i < dialogue_callables.size() - 1:
			await controller.battle_ui.wait_for_dialogue_continuation()


func check_stat_increase(controller: BattleController, stat_name: String, value: int, is_plural: bool) -> void:
	var plural_add: String = "s" if is_plural else ""
	if value > 0:
		dialogue_callables.append(stat_increase_dialogue.bind(controller, stat_name, value, plural_add))


func stat_increase_dialogue(controller: BattleController, stat_name: String, value: int, plural_add: String) -> void:
	await controller.battle_ui.show_line(
		GeneralDialogueProvider.DialogueID.StatIncrease,
		[stat_name, plural_add, value]
	)


func spell_learned_dialogue(controller: BattleController) -> void:
	await controller.battle_ui.show_line(GeneralDialogueProvider.DialogueID.NewSpell)
