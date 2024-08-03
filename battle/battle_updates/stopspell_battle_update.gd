extends BattleUpdate
class_name StopSpellBattleUpdate

var target: BattleUnit
var spell_just_hit: bool = false

func _init(t: BattleUnit, s: bool) -> void:
	target = t
	spell_just_hit = s

func execute(controller: BattleController) -> void:
	if spell_just_hit:
		await controller.battle_ui.show_line_from_data(target.stopspell_dialogue, [target.get_unit_name()])
	else:
		await controller.battle_ui.show_line(GeneralDialogueProvider.DialogueID.BattleSpellBlocked)
