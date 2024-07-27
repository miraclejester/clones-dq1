extends RefCounted
class_name BattleUpdate


func execute(_controller: BattleController) -> void:
	pass


func finish(controller: BattleController) -> void:
	controller.battle_update_finished.emit()
