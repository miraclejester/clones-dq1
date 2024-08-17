extends DialogueCondition
class_name AccessoryEquippedDialogueCondition

@export var accessory_id: int

func evaluate(_window: DialogueWindow, _params: Dictionary) -> bool:
	return PlayerManager.hero.equipment.is_accessory_equipped(accessory_id)
