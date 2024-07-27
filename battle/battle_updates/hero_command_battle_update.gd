extends BattleUpdate
class_name HeroCommandBattleUpdate


func execute(controller: BattleController) -> void:
	controller.ask_command()
	await controller.get_tree().process_frame
	finish(controller)
