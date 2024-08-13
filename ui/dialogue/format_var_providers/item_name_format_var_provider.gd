extends FormatVarProvider
class_name ItemNameFormatVarProvider

@export var item: ItemData

func get_format_var() -> Variant:
	return item.item_name
