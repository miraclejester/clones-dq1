extends BattleUpdate
class_name PlayerHurtBattleUpdate

var hero_unit: HeroUnit
var damage: int


func _init(u: HeroUnit, d: int) -> void:
	hero_unit = u
	damage = d


func execute(controller: BattleController) -> void:
	controller.battle_ui.determine_ui_colors(hero_unit.stats.hp, hero_unit.stats.max_hp)
	await controller.battle_ui.show_line(
		GeneralDialogueProvider.DialogueID.BattlePlayerHurt,
		[damage]
	)
	controller.battle_ui.update_hud()
