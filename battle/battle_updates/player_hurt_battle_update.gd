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
	await controller.battle_ui.show_line(
		GeneralDialogueProvider.DialogueID.BattlePlayerHurt,
		[damage]
	)
	controller.battle_ui.determine_ui_colors(hero_unit.stats.hp, hero_unit.stats.max_hp)
	controller.battle_ui.update_player_stat(PlayerHUD.HUDStatKey.HP, hp_value)
