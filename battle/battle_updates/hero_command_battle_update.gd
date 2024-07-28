extends BattleUpdate
class_name HeroCommandBattleUpdate


func execute(controller: BattleController) -> void:
	await controller.ask_command()
	finish(controller)
