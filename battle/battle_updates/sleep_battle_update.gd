extends BattleUpdate
class_name SleepBattleUpdate

var target: BattleUnit
var just_hit: bool = false

func _init(t: BattleUnit, j: bool) -> void:
	target = t
	just_hit = j


func execute(controller: BattleController) -> void:
	if not target.has_status(BattleUnit.StatusEffect.SLEEP):
		await controller.battle_ui.show_line_from_data(
			target.awake_dialogue,
			target.get_awake_format_vars()
		)
		return
	if just_hit:
		await controller.battle_ui.show_line_from_data(
			target.sleep_started_dialogue,
			target.get_sleep_started_format_vars()
		)
	else:
		await controller.battle_ui.show_line_from_data(
			target.sleep_continues_dialogue,
			target.get_sleep_continues_format_vars()
		)
	await controller.battle_ui.show_newline()
	
