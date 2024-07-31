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
	await controller.battle_ui.show_line(
		GeneralDialogueProvider.DialogueID.BattleEnemyDefeated,
		[enemy_name]
	)
	await controller.battle_ui.show_newline()
	controller.enemy_controller.visible = false
	await controller.battle_ui.show_line(
		GeneralDialogueProvider.DialogueID.BattleExpGain,
		[xp],
	)
	await controller.battle_ui.show_line(
		GeneralDialogueProvider.DialogueID.BattleGoldGain,
		[gold],
	)
	controller.battle_ui.update_player_stat(PlayerHUD.HUDStatKey.XP, xp)
	controller.battle_ui.update_player_stat(PlayerHUD.HUDStatKey.GP, gold)
	await controller.battle_ui.show_newline()
