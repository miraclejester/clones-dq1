extends BattleUpdate
class_name SpellBattleUpdate

var spell_name: String
var user: BattleUnit
var target: BattleUnit
var spell_updates: Array[BattleUpdate]


func _init(sn: String, u: BattleUnit, t: BattleUnit, su: Array[BattleUpdate]) -> void:
	spell_name = sn
	user = u
	target = t
	spell_updates = su


func execute(controller: BattleController) -> void:
	await controller.battle_ui.show_line(
		GeneralDialogueProvider.DialogueID.BattleChantSpell,
		[user.get_unit_name(), spell_name]
	)
	for update in spell_updates:
		await update.execute(controller)
