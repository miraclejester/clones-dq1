extends Control
class_name ItemWindow

signal item_selected(item: ItemData)
signal cancelled()

@onready var command_window: CommandWindow = $CommandWindow
var inventory: Array[ItemStack]


func _ready() -> void:
	command_window.selected.connect(command_selected)
	command_window.cancelled.connect(command_cancelled)


func set_items(inv: Array[ItemStack]) -> void:
	inventory.assign(inv)
	var item_names: Array[String] = []
	item_names.assign(inventory.map(func (stack: ItemStack): return stack.item.item_name))
	command_window.initialize_commands(item_names, 1)


func command_selected(idx: int) -> void:
	item_selected.emit(inventory[idx].item)


func command_cancelled() -> void:
	cancelled.emit()


func activate() -> void:
	command_window.activate()


func deactivate() -> void:
	command_window.deactivate()
