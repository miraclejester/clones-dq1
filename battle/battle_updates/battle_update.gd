extends RefCounted
class_name BattleUpdate


func execute(controller: BattleController) -> void:
	await controller.get_tree().process_frame
