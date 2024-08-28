extends BattleUpdate
class_name FinishBattleUpdate

var wait_for_dialogue: bool
var status: BattleController.BattleEndStatus

func _init(w: bool = true, s: BattleController.BattleEndStatus = BattleController.BattleEndStatus.VICTORY) -> void:
	wait_for_dialogue = w
	status = s


func execute(controller: BattleController) -> void:
	AudioManager.play_bgm(controller.config.field_bgm)
	await controller.finish_battle(status)
