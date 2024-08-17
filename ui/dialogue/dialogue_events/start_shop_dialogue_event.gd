extends DialogueEvent
class_name StartShopDialogueEvent

@export var shop_data: ShopData

func execute(window: DialogueWindow, params: Dictionary) -> void:
	await window.get_tree().process_frame
	window.visible = false
	var shop: ShopInterface = params.get("shop_interface")
	var sd: ShopData = params.get("start_shop_shop_data", shop_data)
	await MenuStack.push_stack(
		shop,
		shop.activate,
		shop.deactivate,
		func ():
			await MenuStack.pop_stack()
			shop.visible = false
	)
	shop.start(sd)
	await shop.cancelled
