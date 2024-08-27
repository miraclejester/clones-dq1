extends DialogueEvent
class_name GrantItemDialogueEvent

@export var item: ItemData


func execute(window: DialogueWindow, params: Dictionary) -> void:
	await window.get_tree().process_frame
	if item is EquipmentData:
		PlayerManager.hero.equipment.equip(item as EquipmentData)
	else:
		PlayerManager.hero.inventory.add_item(params.get("grant_item_item", item))
