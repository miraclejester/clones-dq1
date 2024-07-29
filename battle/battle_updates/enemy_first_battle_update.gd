extends BattleUpdate
class_name EnemyFirstBattleUpdate

var enemy_name: String
var hero_name: String

static func from_data(e: String, h: String) -> EnemyFirstBattleUpdate:
	var res: EnemyFirstBattleUpdate = EnemyFirstBattleUpdate.new()
	res.enemy_name = e
	res.hero_name = h
	return res


func execute(controller: BattleController) -> void:
	await controller.battle_ui.show_battle_paragraph(
		GeneralDialogueProvider.DialogueID.BattleEnemyFirst,
		[enemy_name, hero_name]
	)
	finish(controller)
