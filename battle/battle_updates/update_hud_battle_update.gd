extends BattleUpdate
class_name UpdateHUDBattleUpdate


var hud_key: PlayerHUD.HUDStatKey
var new_val: int
var user: BattleUnit

func _init(k: PlayerHUD.HUDStatKey, n: int, u: BattleUnit) -> void:
	hud_key = k
	new_val = n
	user = u

func execute(controller: BattleController) -> void:
	if user is HeroUnit:
		controller.battle_ui.determine_ui_colors(
			user.stats.get_stat(UnitStats.StatKey.HP),
			user.stats.get_base(UnitStats.StatKey.HP)
		)
	controller.battle_ui.update_player_stat(hud_key, new_val)
	await controller.get_tree().process_frame
