extends BattleUpdate
class_name PlayDialogueBattleUpdate

var dialogue: DialogueEvent
var format_vars: Array = []
var include_newline: bool


func _init(d: DialogueEvent, f: Array, n: bool) -> void:
	dialogue = d
	format_vars = f
	include_newline = n


func execute(controller: BattleController) -> void:
	await controller.battle_ui.show_line_from_data(
		dialogue, format_vars
	)
	if include_newline:
		await controller.battle_ui.show_newline()
