extends DialogueCondition
class_name HasItemDialogueCondition

@export var item: ItemData

func evaluate(_window: DialogueWindow, _params: Dictionary) -> bool:
	return PlayerManager.hero.inventory.has_item(item)
