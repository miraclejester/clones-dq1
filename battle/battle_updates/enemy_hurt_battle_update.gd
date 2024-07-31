extends BattleUpdate
class_name EnemyHurtBattleUpdate

var enemy_name: String
var damage: int


func _init(e: String, d: int) -> void:
	enemy_name = e
	damage = d


func execute(controller: BattleController) -> void:
	await controller.enemy_controller.play_hurt_animation()
	await controller.battle_ui.show_line(
		GeneralDialogueProvider.DialogueID.BattleEnemyHurt,
		[enemy_name, damage]
	)
