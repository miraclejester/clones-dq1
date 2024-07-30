extends BattleUpdate
class_name NoSpellBattleUpdate

var hero_name: String

static func from_data(h: String) -> NoSpellBattleUpdate:
	var res: NoSpellBattleUpdate = NoSpellBattleUpdate.new()
	res.hero_name = h
	return res


func execute(controller: BattleController)  -> void:
	await controller.battle_ui.show_line(GeneralDialogueProvider.DialogueID.BattleNoSpells, [hero_name])
	await controller.battle_ui.show_newline()
	finish(controller)
