extends BattleUpdate
class_name PlayOneShotBGMBattleUpdate

var bgm_key: String

func _init(k: String) -> void:
	bgm_key = k

func execute(controller: BattleController) -> void:
	await controller.battle_ui.show_newline()
	await AudioManager.play_bgm_one_shot(bgm_key)
	controller.reprise_battle_bgm()
