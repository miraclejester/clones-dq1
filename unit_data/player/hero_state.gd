extends RefCounted
class_name HeroState

var hp: int
var mp: int
var level: int
var gold: int
var hero_name: String
var inventory: Array[ItemStack] = []

func add_item(item: ItemData) -> void:
	var stack: ItemStack = find_stack(item.item_id)
	if stack == null:
		inventory.append(ItemStack.new(item, 1))
	else:
		stack.add_item(1)


func remove_item(item: ItemData) -> void:
	var stack: ItemStack = find_stack(item.item_id)
	if stack == null:
		return
	
	if stack.amount == 1:
		inventory.erase(stack)
	else:
		stack.add_item(-1)


func find_stack(id: int) -> ItemStack:
	for stack in inventory:
		if stack.item.item_id == id:
			return stack
	return null


func has_item(item: ItemData) -> bool:
	return find_stack(item.item_id) != null
