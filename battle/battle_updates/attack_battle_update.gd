extends BattleUpdate
class_name AttackBattleUpdate

enum AttackResult {
	DODGE,
	HIT,
	CRIT,
	NO_DAMAGE
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
	await controller.battle_ui.show_line(
		GeneralDialogueProvider.DialogueID.BattleUnitAttacks,
		[attacker.get_unit_name()]
	)
	await controller.get_tree().create_timer(0.5).timeout
	
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
	finish(controller)


func hit(controller: BattleController) -> void:
	if defender is EnemyUnit:
		await controller.enemy_controller.play_hurt_animation()
	else:
		controller.battle_ui.determine_ui_colors(defender.stats.hp, defender.stats.max_hp)
	var dialogue_id: GeneralDialogueProvider.DialogueID
	var format_vars: Array
	if defender is EnemyUnit:
		dialogue_id = GeneralDialogueProvider.DialogueID.BattleEnemyHurt
		format_vars = [defender.get_unit_name(), damage]
	else:
		dialogue_id = GeneralDialogueProvider.DialogueID.BattlePlayerHurt
		format_vars = [damage]
	
	await controller.battle_ui.show_line(
		dialogue_id,
		format_vars
	)
	if attacker is EnemyUnit:
		controller.battle_ui.update_hud()


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
