extends DialogueCondition
class_name HasItemDialogueCondition

@export var item: ItemData

func evaluate(_window: DialogueWindow, params: Dictionary) -> bool:
	return PlayerManager.hero.inventory.has_item(params.get("grant_item_item", item))
