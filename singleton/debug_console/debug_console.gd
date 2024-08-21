extends CanvasLayer

@export var map_load_params: MapLoadParams

@onready var command_window: CommandWindow = %CommandWindow
@onready var player_hud: PlayerHUD = %PlayerHud

enum DebugContext {
	MAIN, TELEPORT, SET_STATS, ADD_ITEM
}

var debug_context: DebugContext
var cur_hero: HeroUnit

func _ready() -> void:
	visible = false
	show_main_commands()


func _process(_delta: float) -> void:
	if visible == false and Input.is_action_just_pressed("debug"):
		get_tree().paused = true
		show_window()


func show_window() -> void:
	visible = true
	if cur_hero != PlayerManager.hero:
		cur_hero = PlayerManager.hero
		player_hud.set_hero(PlayerManager.hero, true)
	show_main_commands()
	await MenuStack.push_stack(
		command_window,
		command_window.activate,
		command_window.deactivate,
		on_cancel
	)


func show_main_commands() -> void:
	debug_context = DebugContext.MAIN
	var commands: Array[CommandData] = [
		CommandData.new("Teleport", teleport_selected),
		CommandData.new("Set Stats", set_stats_selected),
		CommandData.new("Add 100 Gold", add_gold.bind(100)),
		CommandData.new("Add Item", add_item_selected)
	]
	command_window.initialize_commands(commands, 1)


func teleport_selected() -> void:
	await get_tree().process_frame
	debug_context = DebugContext.TELEPORT
	var commands: Array[CommandData] = []
	for key in GameDataManager.get_all_map_keys():
		commands.append(CommandData.new(key, teleport_to_map.bind(key)))
	command_window.initialize_commands(commands, 1)


func add_item_selected() -> void:
	player_hud.visible = false
	await get_tree().process_frame
	debug_context = DebugContext.ADD_ITEM
	var commands: Array[CommandData] = []
	for item in GameDataManager.get_all_non_equipments():
		commands.append(CommandData.new(item.item_name, func (): PlayerManager.hero.inventory.add_item(item), 0, true))
	command_window.initialize_commands(commands, 2)


func set_stats_selected() -> void:
	await get_tree().process_frame
	debug_context = DebugContext.SET_STATS
	var commands: Array[CommandData] = [
		CommandData.new("Level Up", func (): 
			cur_hero.add_exp(PlayerManager.get_exp_for_next_level(), true)
			),
		CommandData.new("Heal", func ():
			cur_hero.stats.set_stat(UnitStats.StatKey.HP, cur_hero.stats.get_base(UnitStats.StatKey.HP))
			cur_hero.stats.set_stat(UnitStats.StatKey.MP, cur_hero.stats.get_base(UnitStats.StatKey.MP))
			),
		CommandData.new("Add 10 HP", func():
			cur_hero.stats.modify_stat(UnitStats.StatKey.HP, 10)
			),
		CommandData.new("Remove 10 HP", func():
			cur_hero.stats.modify_stat(UnitStats.StatKey.HP, -10)
			),
		CommandData.new("Add 10 MP", func():
			cur_hero.stats.modify_stat(UnitStats.StatKey.MP, 10)
			),
		CommandData.new("Remove 10 MP", func():
			cur_hero.stats.modify_stat(UnitStats.StatKey.MP, -10)
			)
	]
	command_window.initialize_commands(commands, 1)


func add_gold(amount: int) -> void:
	cur_hero.add_gold(amount)


func teleport_to_map(key: String) -> void:
	var controller: FieldMapController = get_tree().get_first_node_in_group("map_controller") as FieldMapController
	exit_debug()
	controller.transition_to_map(key, map_load_params)


func on_cancel() -> void:
	match debug_context:
		DebugContext.MAIN:
			await exit_debug()
		DebugContext.TELEPORT, DebugContext.SET_STATS, DebugContext.ADD_ITEM:
			await get_tree().process_frame
			player_hud.visible = true
			show_main_commands()


func exit_debug() -> void:
	await MenuStack.pop_stack()
	visible = false
	get_tree().paused = not MenuStack.is_stack_empty()
