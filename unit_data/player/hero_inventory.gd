extends RefCounted
class_name HeroInventory

var items: Array[ItemStack] = []

func stack_count() -> int:
	return items.size()

func add_item(item: ItemData) -> void:
	var stack: ItemStack = find_stack(item.item_id)
	if stack == null:
		items.append(ItemStack.new(item, 1))
	else:
		stack.add_to_stack(1)


func remove_item(item: ItemData) -> void:
	var stack: ItemStack = find_stack(item.item_id)
	if stack == null:
		return
	
	if stack.amount == 1:
		items.erase(stack)
	else:
		stack.add_to_stack(-1)


func remove_stack(item: ItemData) -> void:
	var stack: ItemStack = find_stack(item.item_id)
	if stack != null:
		items.erase(stack)


func find_items_by_tag(tag: ItemData.ItemTag) -> Array[ItemData]:
	var res: Array[ItemData] = []
	for stack in items:
		if stack.item.tags.has(tag):
			res.append(stack.item)
	return res


func find_stack(id: int) -> ItemStack:
	for stack in items:
		if stack.item.item_id == id:
			return stack
	return null


func get_item_amount(id: int) -> int:
	var stack: ItemStack = find_stack(id)
	if stack != null:
		return stack.amount
	else:
		return 0


func has_item(item: ItemData) -> bool:
	return find_stack(item.item_id) != null


func generate_save_data() -> Array[Dictionary]:
	var res: Array[Dictionary] = []
	for stack in items:
		res.append({
			"id": stack.item.item_id,
			"amount": stack.amount
		})
	return res

func load_from_data(data: Array[Dictionary]) -> void:
	for stack in data:
		for i in range(stack.get("amount", 0)):
			add_item(GameDataManager.get_item(stack.get("id") as int))
