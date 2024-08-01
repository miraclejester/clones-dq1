extends BattleUpdate
class_name SleepHitBattleUpdate

var target: BattleUnit

func _init(t: BattleUnit) -> void:
	target = t


func execute(controller: BattleController) -> void:
	await controller.battle_ui.show_line_from_data(
		target.sleep_started_dialogue,
		target.get_sleep_started_format_vars()
	)
	await controller.battle_ui.show_newline()
	
