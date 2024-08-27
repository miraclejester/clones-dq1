extends Resource
class_name ItemData

enum ItemTag {
	CURSED,
	RAINBOW_DROP_COMPONENT
}

@export var item_name: String
@export var item_id: int
@export var buy_price: int
@export var sell_price: int
@export var consumable: bool
@export var sellable: bool = true
@export var stack_size: int = 1
@export var consumable_condition: DialogueCondition
@export var use_dialogue: DialogueEvent
@export var battle_action: ActionData
@export var field_action: DialogueEvent
@export var tags: Array[ItemTag]
