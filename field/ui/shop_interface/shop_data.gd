extends Resource
class_name ShopData

@export var can_sell: bool = false
@export var is_single_item_shop: bool = false
@export var single_item_price: int = 53
@export var single_item: ItemData
@export var single_item_limit: int
@export var items: Array[ItemData]
@export var dialogues: ShopDialogueSet
