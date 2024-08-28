extends DialogueCondition
class_name HasItemDialogueCondition

@export var item: ItemData

func evaluate(_window: DialogueWindow, params: Dictionary) -> bool:
	var i: ItemData = params.get("grant_item_item", item) as ItemData
	if i is EquipmentData:
		return PlayerManager.hero.equipment.get_equip(i.equipment_type) == i
	else:
		return PlayerManager.hero.inventory.has_item(params.get("grant_item_item", item))
