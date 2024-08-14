extends Control
class_name FileSelect

@export var next_scene: PackedScene

@onready var main_menu: CommandWindow = %MainMenu
@onready var adventure_logs: CommandWindow = $AdventureLogs
@onready var name_entry_window: NameEntryWindow = %NameEntryWindow
@onready var message_speed_selector: MessageSpeedSelector = %MessageSpeedSelector
@onready var filled_adventure_logs: CommandWindow = %FilledAdventureLogs
@onready var yes_no_window: CommandWindow = $YesNoWindow
@onready var file_data_display: FileDataDisplay = %FileDataDisplay


var target_file_idx: int = 1
var chosen_name: String = ""


func _ready() -> void:
	AudioManager.play_bgm("town")
	hide_adventure_logs()
	populate_main_menu()
	name_entry_window.visible = false
	message_speed_selector.visible = false
	filled_adventure_logs.visible = false
	yes_no_window.visible = false
	file_data_display.visible = false


func populate_main_menu() -> void:
	var commands: Array[CommandData] = []
	var filled_slots: Array[int] = GameDataManager.get_filled_slots()
	var num_slots: int = filled_slots.size()
	
	if num_slots > 0:
		commands.append(CommandData.new("CONTINUE A QUEST", show_filled_adventure_logs.bind(filled_slots, start_from_data)))
		commands.append(CommandData.new("CHANGE MESSAGE SPEED", show_filled_adventure_logs.bind(filled_slots, change_existing_speed_ui)))
	if num_slots < 3:
		commands.append(CommandData.new("BEGIN A NEW QUEST", show_adventure_logs.bind(
			filled_slots,
			show_name_entry_for_slot,
			func ():
				hide_adventure_logs()
				await MenuStack.pop_stack()
		)))
	if num_slots > 0 and num_slots < 3:
		commands.append(CommandData.new("COPY A QUEST", show_filled_adventure_logs.bind(filled_slots, slot_selected_for_copy.bind(filled_slots))))
	if num_slots > 0:
		commands.append(CommandData.new("ERASE A QUEST", show_filled_adventure_logs.bind(
			filled_slots,
			slot_selected_for_erase
		)))
	main_menu.initialize_commands(commands, 1)
	await MenuStack.push_stack(
		main_menu,
		main_menu.activate,
		main_menu.deactivate,
		func ():
			main_menu.set_selection(0)
	)


func repopulate_main_menu() -> void:
	await MenuStack.pop_stack()
	populate_main_menu()


func show_adventure_logs(filled_slots: Array[int], on_log_selected: Callable, on_closed: Callable) -> void:
	var logs: Array[CommandData] = []
	logs.assign([1, 2, 3]
		.filter(func (slot: int): return not filled_slots.has(slot))
		.map(func (slot: int):
			return CommandData.new(
				"ADVENTURE LOG %d" % slot,
				on_log_selected.bind(slot)
			)
	))
	adventure_logs.visible = true
	adventure_logs.initialize_commands(logs, 1)
	MenuStack.push_stack(
		adventure_logs,
		adventure_logs.activate,
		adventure_logs.deactivate,
		on_closed
	)


func show_filled_adventure_logs(filled_logs: Array[int], log_callable: Callable) -> void:
	var logs: Array[CommandData] = []
	logs.assign(
		filled_logs.map(
			func (slot: int):
				GameDataManager.load_save_from_slot(slot)
				var data: Dictionary = GameDataManager.get_save_data()
				var hero_name: String = (data.get("player").get("hero_name") as String)
				return CommandData.new(
					"ADVENTURE LOG %d:%s" % [slot, hero_name.substr(0, 4)],
					log_callable.bind(slot)
				))
	)
	filled_adventure_logs.visible = true
	filled_adventure_logs.initialize_commands(logs, 1)
	MenuStack.push_stack(
		filled_adventure_logs,
		filled_adventure_logs.activate,
		filled_adventure_logs.deactivate,
		func ():
			filled_adventure_logs.visible = false
			await MenuStack.pop_stack()
	)


func show_yes_no_window(on_yes: Callable, on_no: Callable) -> void:
	var commands: Array[CommandData] = [
		CommandData.new("YES", on_yes),
		CommandData.new("NO", on_no)
	]
	yes_no_window.visible = true
	yes_no_window.initialize_commands(commands, 1)
	MenuStack.push_stack(
		yes_no_window,
		yes_no_window.activate,
		yes_no_window.deactivate,
		on_no
	)


func hide_adventure_logs() -> void:
	adventure_logs.visible = false


func show_name_entry_for_slot(idx: int) -> void:
	GameDataManager.current_file_index = idx
	show_name_entry_window()


func show_name_entry_window() -> void:
	MenuStack.push_stack(name_entry_window, name_entry_window.activate, name_entry_window.deactivate, name_entry_window.back)
	name_entry_window.visible = true
	chosen_name = await name_entry_window.name_filled
	show_message_speed_selector(speed_selected_for_new_game, cancel_speed_for_new_game)


func change_existing_speed_ui(slot: int) -> void:
	show_message_speed_selector(
		func (speed: int):
			change_message_speed(slot, speed)
			await MenuStack.pop_stack()
			await MenuStack.pop_stack()
			message_speed_selector.visible = false
			filled_adventure_logs.visible = false,
		func ():
			await MenuStack.pop_stack()
			await MenuStack.pop_stack()
			message_speed_selector.visible = false
			filled_adventure_logs.visible = false
	)


func change_message_speed(slot: int, speed: int) -> void:
	GameDataManager.load_save_from_slot(slot)
	GameSettings.set_message_speed(speed)
	GameDataManager.save_game(true)


func slot_selected_for_copy(slot: int, filled_slots: Array[int]) -> void:
	var close: Callable = func():
		await MenuStack.pop_stack()
		await MenuStack.pop_stack()
		hide_adventure_logs()
		filled_adventure_logs.visible = false
	
	show_adventure_logs(
		filled_slots,
		func (idx: int):
			show_yes_no_window(
				func ():
					GameDataManager.copy_file(slot, idx)
					await MenuStack.pop_stack()
					yes_no_window.visible = false
					close.call()
					await repopulate_main_menu(),
				func ():
					await MenuStack.pop_stack()
					yes_no_window.visible = false
					close.call()
			),
		close
	)


func slot_selected_for_erase(slot: int) -> void:
	var close: Callable = func():
		await MenuStack.pop_stack()
		await MenuStack.pop_stack()
		yes_no_window.visible = false
		filled_adventure_logs.visible = false
		file_data_display.visible = false
	
	GameDataManager.load_save_from_slot(slot)
	var data: Dictionary = GameDataManager.get_save_data()
	var player_data: Dictionary = data.get("player")
	file_data_display.set_data(player_data.get("hero_name"), player_data.get("level"))
	file_data_display.visible = true
	
	show_yes_no_window(
		func ():
			GameDataManager.erase_file(slot)
			await close.call()
			await repopulate_main_menu(),
		close
	)


func show_message_speed_selector(on_speed_selected: Callable, on_cancel: Callable) -> void:
	var cancel: Callable = func ():
		message_speed_selector.speed_selected.disconnect(on_speed_selected)
		on_cancel.call()
	
	message_speed_selector.visible = true
	await MenuStack.push_stack(
		message_speed_selector,
		message_speed_selector.activate,
		message_speed_selector.deactivate,
		cancel
	)
	message_speed_selector.speed_selected.connect(on_speed_selected)


func cancel_speed_for_new_game() -> void:
	message_speed_selector.visible = false
	await MenuStack.pop_stack()
	name_entry_window.visible = false
	await MenuStack.pop_stack()
	hide_adventure_logs()
	await MenuStack.pop_stack()


func speed_selected_for_new_game(speed: int) -> void:
	GameDataManager.create_new_game(chosen_name, speed)
	transition_to_game()


func start_from_data(idx: int) -> void:
	GameDataManager.load_save_from_slot(idx)
	transition_to_game()


func transition_to_game() -> void:
	GlobalVisuals.dark_out()
	GameDataManager.load_from_local_data()
	await MenuStack.clear_menu_stack()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_packed(next_scene)
