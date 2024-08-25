extends DialogueEvent
class_name FullInventoryDialogueEvent

@export var item: ItemData

func execute(_window: DialogueWindow, params: Dictionary) -> void:
	var map_controller: FieldMapController = params.get("map_controller") as FieldMapController
	map_controller.field_ui.full_inventory_flow(params.get("grant_item_item", item))
	await map_controller.field_ui.full_inventory_flow_finished
