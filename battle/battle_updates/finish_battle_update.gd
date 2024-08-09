extends BattleUpdate
class_name FinishBattleUpdate

var wait_for_dialogue: bool

func _init(w: bool = true) -> void:
	wait_for_dialogue = w


func execute(controller: BattleController) -> void:
	AudioManager.play_bgm(controller.config.field_bgm)
	if wait_for_dialogue:
		await controller.battle_ui.wait_for_dialogue_continuation(controller.encounter_data.after_victory_event != null)
	await controller.finish_battle()
