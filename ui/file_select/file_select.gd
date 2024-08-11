extends Control
class_name FileSelect

@onready var main_menu: CommandWindow = %MainMenu
@onready var adventure_logs = $AdventureLogs

var current_menu_callables: Array[Callable]


func _ready() -> void:
	current_menu_callables = []
	main_menu.selected.connect(menu_item_selected)
	hide_adventure_logs()
	populate_main_menu()


func populate_main_menu() -> void:
	var commands: Array[String] = []
	var available_slots: Array[int] = GameDataManager.get_available_slots()
	
	if available_slots.size() < 3:
		commands.append("CONTINUE A QUEST")
		current_menu_callables.append(func(): pass)
		commands.append("CHANGE MESSAGE SPEED")
		current_menu_callables.append(func(): pass)
	if available_slots.size() > 0:
		commands.append("BEGIN A NEW QUEST")
		current_menu_callables.append(show_adventure_logs.bind(available_slots))
	if available_slots.size() < 3:
		commands.append("COPY A QUEST")
		current_menu_callables.append(func(): pass)
		commands.append("ERASE A QUEST")
		current_menu_callables.append(func(): pass)
	main_menu.initialize_commands(commands, 1)
	await MenuStack.push_stack(
		main_menu,
		main_menu.activate,
		main_menu.deactivate,
		func ():
			main_menu.set_selection(0)
	)


func show_adventure_logs(empty_slots: Array[int]) -> void:
	var logs: Array[String] = []
	logs.assign([1, 2, 3]
		.filter(func (slot: int): return not empty_slots.has(slot))
		.map(func (slot: int): return "ADVENTURE LOG %d" % slot)
	)
	adventure_logs.visible = true
	adventure_logs.initialize_commands(logs, 1)
	MenuStack.push_stack(
		adventure_logs,
		adventure_logs.activate,
		adventure_logs.deactivate,
		func ():
			hide_adventure_logs()
			await MenuStack.pop_stack()
	)


func hide_adventure_logs() -> void:
	adventure_logs.visible = false


func menu_item_selected(idx: int) -> void:
	await current_menu_callables[idx].call()
