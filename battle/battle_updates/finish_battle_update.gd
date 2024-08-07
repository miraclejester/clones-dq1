extends BattleUpdate
class_name FinishBattleUpdate

var wait_for_dialogue: bool

func _init(w: bool = true) -> void:
	wait_for_dialogue = w


func execute(controller: BattleController) -> void:
	AudioManager.play_bgm(BGMEntry.BGMKey.Overworld)
	if wait_for_dialogue:
		await controller.battle_ui.wait_for_dialogue_continuation(false)
	controller.finish_battle()
	await controller.get_tree().process_frame
