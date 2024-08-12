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
	var routines: Array[Callable] = [AudioManager.play_bgm_one_shot.bind("victory")]
	if controller.show_spoils:
		routines.append(show_spoils_dialogue.bind(controller))
	await ParallelPromise.new(routines).run_all()


func show_spoils_dialogue(controller: BattleController) -> void:
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
