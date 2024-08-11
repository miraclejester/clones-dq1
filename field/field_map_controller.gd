extends Node2D
class_name FieldMapController

@export_dir var base_map_path: String
@export var talk_default_dialogue: DialogueEvent


@onready var hero_character: HeroCharacter = %HeroCharacter
@onready var field_ui: FieldUI = $FieldUI
@onready var field_map_container: Node2D = $FieldMapContainer
@onready var save_data_handler = %SaveDataHandler



var field_map: FieldMap
var current_map_key: String


func _ready() -> void:
	save_data_handler.register_save_callable(generate_save_data)
	load_map("brecconary/tantegel_throne")
	
	hero_character.idling.connect(on_hero_idling)
	hero_character.move_intention.connect(on_hero_move_intention)
	hero_character.menu_requested.connect(on_hero_menu_requested)
	hero_character.set_current_map(field_map)
	
	field_ui.command_cancelled.connect(on_command_cancelled)
	field_ui.talk_selected.connect(on_talk_selected)
	
	GlobalVisuals.determine_ui_colors(
		PlayerManager.hero.stats.get_stat(UnitStats.StatKey.HP),
		PlayerManager.hero.stats.get_base(UnitStats.StatKey.HP)
	)


func load_map(path: String) -> void:
	current_map_key = path
	var map_scene: PackedScene = load("%s/%s.tscn" % [base_map_path, path])
	var map: FieldMap = map_scene.instantiate() as FieldMap
	field_map = map
	field_map_container.add_child(field_map)
	AudioManager.play_bgm(field_map.map_bgm)


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
			PlayParagraphDialogueEvent.ParagraphEventKeys.FORMAT_VARS : [
				PlayerManager.hero.get_unit_name(),
				PlayerManager.get_exp_for_next_level()
			]
		})
	else:
		await field_ui.play_dialogue(talk_default_dialogue)
	close_command_window()


func generate_save_data() -> SaveDataEntry:
	return SaveDataEntry.new("map", {
		"map_key": current_map_key
	})
