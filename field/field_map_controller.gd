extends Node2D
class_name FieldMapController

@export_dir var base_map_path: String
@export var talk_default_dialogue: DialogueEvent
@export var take_default_dialogue: DialogueEvent


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
	
	#if field_map.map_start_event != null:
	#	await get_tree().process_frame
	#	get_tree().paused = true
	#	await field_ui.play_dialogue(field_map.map_start_event, {
	#		PlayParagraphDialogueEvent.ParagraphEventKeys.FORMAT_VARS : get_global_format_vars()
	#	})
	#	get_tree().paused = false
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


func get_global_format_vars() -> Array:
	return [
		PlayerManager.hero.get_unit_name(),
		PlayerManager.get_exp_for_next_level()
	]
