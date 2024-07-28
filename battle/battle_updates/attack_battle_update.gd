extends BattleUpdate
class_name AttackBattleUpdate

enum AttackResult {
	DODGE,
	HIT,
	CRIT
}

var result: AttackResult
var attacker: BattleUnit
var defender: BattleUnit
var damage: int

static func fromData(r: AttackResult, a: BattleUnit, def: BattleUnit, dmg: int) -> AttackBattleUpdate:
	var res: AttackBattleUpdate = AttackBattleUpdate.new()
	res.result = r
	res.attacker = a
	res.defender = def
	res.damage = dmg
	return res


func execute(controller: BattleController) -> void:
	await controller.battle_ui.show_battle_paragraph(
		GeneralDialogueProvider.DialogueID.BattleUnitAttacks,
		[attacker.get_unit_name()],
		true
	)
	await controller.get_tree().create_timer(0.5).timeout
	await controller.battle_ui.show_battle_paragraph(
		GeneralDialogueProvider.DialogueID.BattleEnemyHurt,
		[defender.get_unit_name(), damage],
		true
	)
	finish(controller)
