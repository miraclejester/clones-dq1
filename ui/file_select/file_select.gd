extends Control
class_name FileSelect

@onready var main_menu: CommandWindow = %MainMenu
@onready var adventure_logs: CommandWindow = $AdventureLogs
@onready var name_entry_window: NameEntryWindow = %NameEntryWindow

var target_file_idx: int = 1


func _ready() -> void:
	AudioManager.play_bgm("town")
	hide_adventure_logs()
	populate_main_menu()
	name_entry_window.visible = false


func populate_main_menu() -> void:
	var commands: Array[CommandData] = []
	var filled_slots: Array[int] = GameDataManager.get_filled_slots()
	
	if filled_slots.size() > 0:
		commands.append(CommandData.new("CONTINUE A QUEST", func(): pass))
		commands.append(CommandData.new("CHANGE MESSAGE SPEED", func(): pass))
	if filled_slots.size() < 3:
		commands.append(CommandData.new("BEGIN A NEW QUEST", show_adventure_logs.bind(filled_slots)))
	if filled_slots.size() > 0:
		commands.append(CommandData.new("COPY A QUEST", func(): pass))
		commands.append(CommandData.new("ERASE A QUEST", func(): pass))
	main_menu.initialize_commands(commands, 1)
	await MenuStack.push_stack(
		main_menu,
		main_menu.activate,
		main_menu.deactivate,
		func ():
			main_menu.set_selection(0)
	)


func show_adventure_logs(filled_slots: Array[int]) -> void:
	var logs: Array[CommandData] = []
	logs.assign([1, 2, 3]
		.filter(func (slot: int): return not filled_slots.has(slot))
		.map(func (slot: int):
			return CommandData.new(
				"ADVENTURE LOG %d" % slot,
				func ():
					target_file_idx = slot
					show_name_entry_window()
					)
			)
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


func show_name_entry_window() -> void:
	MenuStack.push_stack(name_entry_window, name_entry_window.activate, name_entry_window.deactivate, name_entry_window.back)
	name_entry_window.visible = true
	var final_name: String = await name_entry_window.name_filled
	GameDataManager.generate_new_save_data(final_name)
	name_entry_window.visible = false
	await MenuStack.pop_stack()
	hide_adventure_logs()
	await MenuStack.pop_stack()
