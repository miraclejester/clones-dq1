extends BattleUpdate
class_name ItemBattleUpdate

var item: ItemData
var user: BattleUnit
var updates: Array[BattleUpdate]

func _init(i: ItemData, u: BattleUnit, p: Array[BattleUpdate]) -> void:
	item = i
	user = u
	updates = p


func execute(controller: BattleController) -> void:
	await controller.battle_ui.show_line_from_data(
		item.use_dialogue,
		[user.get_unit_name()]
	)
	for update in updates:
		await update.execute(controller)
	await controller.battle_ui.show_newline()
