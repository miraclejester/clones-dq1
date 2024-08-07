extends BattleUpdate
class_name RunBattleUpdate

enum RunResult {
	SUCCESS,
	FAILURE
}

var hero_name: String
var result: RunResult


static func from_data(n: String, r: RunResult) -> RunBattleUpdate:
	var res: RunBattleUpdate = RunBattleUpdate.new()
	res.hero_name = n
	res.result = r
	return res


func execute(controller: BattleController) -> void:
	AudioManager.play_sfx(SFXEntry.SFXKey.Run)
	await controller.battle_ui.show_line(
		GeneralDialogueProvider.DialogueID.BattleAttemptRun,
		[hero_name]
	)
	match result:
		RunResult.FAILURE:
			await controller.battle_ui.show_line(
				GeneralDialogueProvider.DialogueID.BattleRunFailure,
				[]
			)
			await controller.battle_ui.show_newline()
