extends BattleUpdate
class_name UpdateHUDBattleUpdate


var hud_key: PlayerHUD.HUDStatKey
var new_val: int

func _init(k: PlayerHUD.HUDStatKey, n: int) -> void:
	hud_key = k
	new_val = n

func execute(controller: BattleController) -> void:
	controller.battle_ui.update_player_stat(hud_key, new_val)
	await controller.get_tree().process_frame
