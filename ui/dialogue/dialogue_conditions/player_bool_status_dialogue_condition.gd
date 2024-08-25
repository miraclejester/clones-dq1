extends DialogueCondition
class_name PlayerBoolStatusDialogueCondition

enum PlayerCondition {
	IS_CURSED,
	ITEM_FITS_INVENTORY
}

@export var condition_to_check: PlayerCondition
@export var item: ItemData

func evaluate(_window: DialogueWindow, params: Dictionary) -> bool:
	match condition_to_check:
		PlayerCondition.IS_CURSED:
			return PlayerManager.hero.is_cursed
		PlayerCondition.ITEM_FITS_INVENTORY:
			return PlayerManager.hero.inventory.item_fits_inventory(params.get("grant_item_item", item) as ItemData)
		_:
			return true
