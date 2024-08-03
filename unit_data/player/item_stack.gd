extends RefCounted
class_name ItemStack

var item: ItemData
var amount: int = 0

func _init(i: ItemData, a: int) -> void:
	item = i
	amount = a


func add_to_stack(a: int) -> void:
	amount += a


func remove_from_stack(a: int) -> void:
	add_to_stack(-a)
