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
	await controller.battle_ui.show_battle_paragraph(
		GeneralDialogueProvider.DialogueID.BattleAttemptRun,
		[hero_name]
	)
	match result:
		RunResult.FAILURE:
			await controller.battle_ui.show_battle_paragraph(
				GeneralDialogueProvider.DialogueID.BattleRunFailure,
				[], true
			)
	finish(controller)
