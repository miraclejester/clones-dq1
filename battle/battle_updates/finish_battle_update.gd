extends BattleUpdate
class_name FinishBattleUpdate

func execute(controller: BattleController) -> void:
	controller.finish_battle()
	await controller.get_tree().process_frame
	finish(controller)
