extends BattleUpdate
class_name PlayerHurtBattleUpdate

var hero_unit: HeroUnit
var damage: int
var hp_value: int


func _init(u: HeroUnit, d: int, h: int) -> void:
	hero_unit = u
	damage = d
	hp_value = h


func execute(controller: BattleController) -> void:
	await GlobalVisuals.player_hurt_shake()
	await controller.battle_ui.show_line(
		GeneralDialogueProvider.DialogueID.BattlePlayerHurt,
		[damage]
	)
	controller.battle_ui.determine_ui_colors(
		hero_unit.stats.get_stat(UnitStats.StatKey.HP),
		hero_unit.stats.get_base(UnitStats.StatKey.HP)
	)
	controller.battle_ui.update_player_stat(PlayerHUD.HUDStatKey.HP, hp_value)
