extends BattleUpdate
class_name SpellBattleUpdate

var spell: SpellData
var user: BattleUnit
var target: BattleUnit
var spell_updates: Array[BattleUpdate]
var new_mp: int


func _init(s: SpellData, u: BattleUnit, t: BattleUnit, su: Array[BattleUpdate], m: int) -> void:
	spell = s
	user = u
	target = t
	spell_updates = su
	new_mp = m


func execute(controller: BattleController) -> void:
	await controller.battle_ui.show_line(
		GeneralDialogueProvider.DialogueID.BattleChantSpell,
		[user.get_unit_name(), spell.spell_name]
	)
	AudioManager.play_sfx("spell")
	await user.play_spell_effect()
	if user is HeroUnit:
		controller.battle_ui.update_player_stat(PlayerHUD.HUDStatKey.MP, new_mp)
	for update in spell_updates:
		await update.execute(controller)
	await controller.battle_ui.show_newline()
