extends Resource
class_name ShopDialogueSet

@export_group("Dialogues")
@export var initial_dialogue: DialogueEvent
@export var what_buy_dialogue: DialogueEvent
@export var goodbye_dialogue: DialogueEvent
@export var not_enough_money_dialogue: DialogueEvent
@export var buy_again_dialogue: DialogueEvent
@export var item_selected_dialogue: DialogueEvent
@export var buy_confirm_dialogue: DialogueEvent
@export var item_bought_dialogue: DialogueEvent
@export var buy_cancelled_dialogue: DialogueEvent
@export var rebuy_equipment_dialogue: DialogueEvent
@export var cannot_carry_more: DialogueEvent

@export_group("Sell Dialogues")
@export var sell_confirm_dialogue: DialogueEvent
@export var sell_again_dialogue: DialogueEvent
@export var no_sellable_items_dialogue: DialogueEvent
@export var what_sell_dialogue: DialogueEvent
@export var cursed_item_dialogue: DialogueEvent
@export var cannot_buy_dialogue: DialogueEvent

@export_group("Single Item Dialogues")
@export var cannot_sell_more_dialogue: DialogueEvent
