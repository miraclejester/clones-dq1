extends BattleUpdate
class_name AbilityBattleUpdate

var ability: AbilityData
var user: BattleUnit
var target: BattleUnit
var spell_updates: Array[BattleUpdate]


func _init(a: AbilityData, u: BattleUnit, t: BattleUnit, su: Array[BattleUpdate]) -> void:
	ability = a
	user = u
	target = t
	spell_updates = su


func execute(controller: BattleController) -> void:
	await controller.battle_ui.show_line_from_data(
		ability.use_dialogue,
		[user.get_unit_name()]
	)
	await controller.get_tree().create_timer(1.0).timeout
	for update in spell_updates:
		await update.execute(controller)
	await controller.battle_ui.show_newline()
