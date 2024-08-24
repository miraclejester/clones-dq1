extends DialogueEvent
class_name RemoveItemsByTagDialogueEvent

@export var tag: ItemData.ItemTag
@export var remove_stack: bool = false

func execute(window: DialogueWindow, _params: Dictionary) -> void:
	await window.get_tree().process_frame
	var items: Array[ItemData] = PlayerManager.hero.inventory.find_items_by_tag(tag)
	
	var remove_call: Callable = PlayerManager.hero.inventory.remove_item
	if remove_stack:
		remove_call = PlayerManager.hero.inventory.remove_stack
	for item in items:
		remove_call.call(item)
