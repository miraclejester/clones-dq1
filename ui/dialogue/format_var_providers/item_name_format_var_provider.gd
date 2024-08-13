extends FormatVarProvider
class_name ItemNameFormatVarProvider

@export var item: ItemData

func get_format_var(params: Dictionary = {}) -> Variant:
	var i: ItemData = params.get("item_name_provider_item", item)
	return i.item_name
