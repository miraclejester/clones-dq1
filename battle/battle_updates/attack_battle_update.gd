extends BattleUpdate
class_name AttackBattleUpdate

enum AttackResult {
	DODGE,
	HIT,
	CRIT,
	NO_DAMAGE
}

enum AttackType {
	BASIC,
	SPELL
}

var result: AttackResult
var type: AttackType
var attacker: BattleUnit
var defender: BattleUnit
var damage: int
var new_hp: int

static func fromData(r: AttackResult, a: BattleUnit, def: BattleUnit, dmg: int, h: int) -> AttackBattleUpdate:
	var res: AttackBattleUpdate = AttackBattleUpdate.new()
	res.result = r
	res.attacker = a
	res.defender = def
	res.damage = dmg
	res.new_hp = h
	return res


func execute(controller: BattleController) -> void:
	AudioManager.play_sfx(attacker.get_attack_sfx_key())
	await controller.battle_ui.show_line(
		GeneralDialogueProvider.DialogueID.BattleUnitAttacks,
		[attacker.get_unit_name()]
	)
	
	match result:
		AttackResult.HIT:
			await hit(controller)
		AttackResult.DODGE:
			await miss(controller)
		AttackResult.CRIT:
			await crit(controller)
		AttackResult.NO_DAMAGE:
			await no_damage(controller)
	
	await controller.battle_ui.show_newline()


func hit(controller: BattleController) -> void:
	await defender.get_deal_damage_update(damage, new_hp).execute(controller)


func miss(controller: BattleController) -> void:
	var dialogue_id = GeneralDialogueProvider.DialogueID.BattleMiss
	if defender is EnemyUnit:
		dialogue_id = GeneralDialogueProvider.DialogueID.BattleEnemyDodge
	await controller.battle_ui.show_line(
		dialogue_id
	)


func no_damage(controller: BattleController) -> void:
	await controller.battle_ui.show_line(
		GeneralDialogueProvider.DialogueID.BattleEnemyNoDamage
	)


func crit(controller: BattleController) -> void:
	await controller.battle_ui.show_line(
		GeneralDialogueProvider.DialogueID.BattleExcellentMove
	)
	await hit(controller)
