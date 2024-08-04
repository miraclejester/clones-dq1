extends BattleUpdate
class_name SleepBattleUpdate

var target: BattleUnit
var awakened: bool = false
var just_hit: bool = false

func _init(t: BattleUnit, a: bool, j: bool) -> void:
	target = t
	awakened = a
	just_hit = j


func execute(controller: BattleController) -> void:
	if awakened:
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
	
