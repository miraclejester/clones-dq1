extends Control
class_name ItemWindow

signal item_selected(item: ItemData)
signal cancelled()

@onready var command_window: CommandWindow = $CommandWindow
var inventory: Array[ItemStack]


func _ready() -> void:
	command_window.cancelled.connect(command_cancelled)


func set_items(inv: Array[ItemStack]) -> void:
	inventory.assign(inv)
	var commands: Array[CommandData] = []
	commands.assign(inventory.map(func (stack: ItemStack):
		return CommandData.new(
			stack.item.item_name,
			func (): item_selected.emit(stack.item),
			stack.amount
			)
		)
	)
	command_window.initialize_commands(commands, 1)


func command_cancelled() -> void:
	cancelled.emit()


func activate() -> void:
	command_window.activate()


func deactivate() -> void:
	command_window.deactivate()
