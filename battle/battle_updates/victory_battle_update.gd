extends BattleUpdate
class_name VictoryBattleUpdate

var enemy_name: String
var xp: int
var gold: int

static func from_data(n: String, e: int, g: int) -> VictoryBattleUpdate:
	var res: VictoryBattleUpdate = VictoryBattleUpdate.new()
	res.enemy_name = n
	res.xp = e
	res.gold = g
	return res


func execute(controller: BattleController) -> void:
	await controller.battle_ui.show_battle_paragraph(
		GeneralDialogueProvider.DialogueID.BattleEnemyDefeated,
		[enemy_name]
	)
	controller.enemy_controller.visible = false
	await controller.battle_ui.show_battle_paragraph(
		GeneralDialogueProvider.DialogueID.BattleExpGain,
		[xp],
		true
	)
	await controller.battle_ui.show_battle_paragraph(
		GeneralDialogueProvider.DialogueID.BattleGoldGain,
		[gold],
		true
	)
	controller.battle_ui.update_hud()
	finish(controller)
