extends DialogueEvent
class_name GrantItemDialogueEvent

@export var item: ItemData


func execute(window: DialogueWindow, params: Dictionary) -> void:
	await window.get_tree().process_frame
	PlayerManager.hero.inventory.add_item(params.get("grant_item_item", item))
