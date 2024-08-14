extends Node2D
class_name FieldMapController

@export_dir var base_map_path: String
@export var talk_default_dialogue: DialogueEvent
@export var take_default_dialogue: DialogueEvent
@export var search_initial_dialogue: DialogueEvent
@export var search_default_dialogue: DialogueEvent
@export var door_no_key_dialogue: DialogueEvent
@export var door_default_dialogue: DialogueEvent
@export var item_default_dialogue: DialogueEvent


@onready var hero_character: HeroCharacter = %HeroCharacter
@onready var field_ui: FieldUI = $FieldUI
@onready var field_map_container: Node2D = $FieldMapContainer



var field_map: FieldMap
var current_map_key: String


func _ready() -> void:
	await get_tree().process_frame
	
	hero_character.idling.connect(on_hero_idling)
	hero_character.move_intention.connect(on_hero_move_intention)
	hero_character.menu_requested.connect(on_hero_menu_requested)
	hero_character.set_process(false)
	
	field_ui.command_cancelled.connect(on_command_cancelled)
	field_ui.talk_selected.connect(on_talk_selected)
	field_ui.take_selected.connect(on_take_selected)
	field_ui.search_selected.connect(on_search_selected)
	field_ui.door_selected.connect(on_door_selected)
	field_ui.item_selected.connect(on_item_selected)
	field_ui.status_selected.connect(on_status_selected)
	
	GlobalVisuals.determine_ui_colors(
		PlayerManager.hero.stats.get_stat(UnitStats.StatKey.HP),
		PlayerManager.hero.stats.get_base(UnitStats.StatKey.HP)
	)
	
	load_map(GameDataManager.get_starting_map_key())


func load_map(path: String) -> void:
	current_map_key = path
	var map_scene: PackedScene = load("%s/%s.tscn" % [base_map_path, path])
	var map: FieldMap = map_scene.instantiate() as FieldMap
	field_map = map
	field_map_container.add_child(field_map)
	hero_character.set_current_map(field_map)
	AudioManager.play_bgm(field_map.map_bgm)
	await GlobalVisuals.fade_in()
	
	if field_map.map_start_event != null and false:
		await get_tree().process_frame
		get_tree().paused = true
		await field_ui.play_dialogue(field_map.map_start_event, {
			PlayParagraphDialogueEvent.ParagraphEventKeys.FORMAT_VARS : get_global_format_vars()
		})
		get_tree().paused = false
	hero_character.set_process(true)


func on_hero_idling() -> void:
	field_ui.show_hud()


func on_hero_move_intention() -> void:
	field_ui.hide_hud()


func on_hero_menu_requested() -> void:
	field_ui.show_command_window()
	get_tree().paused = true


func close_command_window() -> void:
	field_ui.hide_command_window()
	get_tree().paused = false


func on_command_cancelled() -> void:
	await MenuStack.pop_stack()
	close_command_window()


func on_talk_selected() -> void:
	await MenuStack.pop_stack()
	
	var npc: NPCCharacter = field_map.find_npc(hero_character.get_facing_tile_position())
	if npc != null and npc.talk_event != null:
		npc.face_towards(hero_character.position)
		await field_ui.play_dialogue(npc.talk_event, {
			PlayParagraphDialogueEvent.ParagraphEventKeys.FORMAT_VARS : get_global_format_vars()
		})
	else:
		await field_ui.play_dialogue(talk_default_dialogue)
	close_command_window()


func on_take_selected() -> void:
	await MenuStack.pop_stack()
	
	var event: MapEvent = field_map.find_event(hero_character.position)
	if event != null and event.take_event != null:
		var params: Dictionary = {
			PlayParagraphDialogueEvent.ParagraphEventKeys.FORMAT_VARS : get_global_format_vars(),
			"map" : field_map
		}
		params.merge(event.get_take_params())
		await field_ui.play_dialogue(event.take_event, params)
	else:
		await field_ui.play_dialogue(take_default_dialogue, {
			PlayParagraphDialogueEvent.ParagraphEventKeys.FORMAT_VARS : get_global_format_vars()
		})
	close_command_window()


func on_search_selected() -> void:
	await MenuStack.pop_stack()
	
	await field_ui.play_dialogue(search_initial_dialogue, {
		PlayParagraphDialogueEvent.ParagraphEventKeys.FORMAT_VARS : [PlayerManager.hero.get_unit_name()]
	})
	
	var event: MapEvent = field_map.find_event(hero_character.position)
	if event != null and event.search_event != null:
		await field_ui.play_dialogue(event.search_event, {}, false)
	else:
		await field_ui.play_dialogue(search_default_dialogue, {}, false)
	close_command_window()


func on_door_selected() -> void:
	await MenuStack.pop_stack()
	
	var event: MapEvent = field_map.find_event(hero_character.get_facing_tile_position())
	if event != null and event.door_event != null:
		var magic_key: ItemData = GameDataManager.get_item(24)
		if PlayerManager.hero.inventory.has_item(magic_key):
			PlayerManager.hero.inventory.remove_item(magic_key)
			var params: Dictionary = {
				"map" : field_map,
				"wait_for_continuation": false,
				"make_window_visible": false
			}
			params.merge(event.get_door_params())
			await field_ui.play_dialogue(event.door_event, params)
		else:
			await field_ui.play_dialogue(door_no_key_dialogue)
	else:
		await field_ui.play_dialogue(door_default_dialogue)
	
	close_command_window()


func on_item_selected() -> void:
	await MenuStack.pop_stack()
	if PlayerManager.hero.inventory.stack_count() > 0:
		field_ui.show_item_window(on_item_data_selected)
	else:
		await field_ui.play_dialogue(item_default_dialogue)
		close_command_window()


func on_item_data_selected(item: ItemData) -> void:
	var clean: bool = false
	if item.use_dialogue != null:
		field_ui.play_dialogue(item.use_dialogue)
		clean = true
	await field_ui.play_dialogue(item.field_action, {
		"wait_for_continuation": false,
		"clean_window": clean,
		"map_controller": self
	})
	close_command_window()


func on_status_selected() -> void:
	await MenuStack.pop_stack()
	await field_ui.show_status_window(
		func ():
			await MenuStack.pop_stack()
			field_ui.hide_status_window()
			await get_tree().process_frame
			close_command_window()
	)


func get_global_format_vars() -> Array:
	return [
		PlayerManager.hero.get_unit_name(),
		PlayerManager.get_exp_for_next_level()
	]
