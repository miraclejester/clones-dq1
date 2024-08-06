extends BattleUpdate
class_name FinishBattleUpdate

func execute(controller: BattleController) -> void:
	await controller.battle_ui.wait_for_dialogue_continuation(false)
	controller.finish_battle()
	await controller.get_tree().process_frame
