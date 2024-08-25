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
@export var default_stairs_dialogue: DialogueEvent
@export var spell_default_dialogue: DialogueEvent
@export var non_field_spell_dialogue: DialogueEvent
@export var starting_map_load_params: MapLoadParams


@onready var hero_character: HeroCharacter = %HeroCharacter
@onready var field_ui: FieldUI = $FieldUI
@onready var field_map_container: Node2D = $FieldMapContainer
@onready var battle_controller: BattleController = $BattleController


var field_map: FieldMap
var current_map_key: String
var damage_effect_dict: Dictionary = {
	2: {
		"sfx": "tile_hit",
		"effect": GlobalVisuals.map_hurt_effect
	},
	15: {
		"sfx": "barrier_hit",
		"effect": GlobalVisuals.map_barrier_effect
	}
}


func _ready() -> void:
	await get_tree().process_frame
	
	hero_character.idling.connect(on_hero_idling)
	hero_character.move_intention.connect(on_hero_move_intention)
	hero_character.menu_requested.connect(on_hero_menu_requested)
	hero_character.move_finished.connect(on_move_finished)
	hero_character.set_process(false)
	
	battle_controller.set_visibility(false)
	battle_controller.battle_finished.connect(on_battle_finished)
	
	field_ui.command_cancelled.connect(on_command_cancelled)
	field_ui.talk_selected.connect(on_talk_selected)
	field_ui.take_selected.connect(on_take_selected)
	field_ui.search_selected.connect(on_search_selected)
	field_ui.door_selected.connect(on_door_selected)
	field_ui.item_selected.connect(on_item_selected)
	field_ui.status_selected.connect(on_status_selected)
	field_ui.stairs_selected.connect(on_stairs_selected)
	field_ui.spell_selected.connect(on_spell_selected)
	
	load_map(GameDataManager.get_starting_map_key(), starting_map_load_params)


func load_map(path: String, params: MapLoadParams) -> void:
	hero_character.visible = false
	
	current_map_key = path
	var map_scene: PackedScene = load("%s/%s.tscn" % [base_map_path, path])
	var map: FieldMap = map_scene.instantiate() as FieldMap
	field_map = map
	for child in field_map_container.get_children():
		field_map_container.remove_child(child)
		child.queue_free()
	field_map.visible = false
	field_map_container.add_child(field_map)
	
	hero_character.set_current_map(field_map)
	if field_map.is_dark:
		hero_character.show_darkness()
	else:
		hero_character.hide_darkness()
	
	hero_character.position = field_map.find_spawn_pos(params.spawn_point_key)
	hero_character.set_face_dir(params.spawn_direction)
	
	await get_tree().create_timer(1).timeout
	AudioManager.play_bgm(field_map.map_bgm)
	
	for event in field_map.get_events():
		if event.map_start_event != null:
			await field_ui.play_dialogue(event.map_start_event, {
				"map": field_map,
				"make_window_visible": false,
				"map_controller": self
			})
	
	hero_character.visible = true
	field_map.visible = true
	await GlobalVisuals.fade_in()
	
	await get_tree().process_frame
	GlobalVisuals.determine_ui_colors(
		PlayerManager.hero.stats.get_stat(UnitStats.StatKey.HP),
		PlayerManager.hero.stats.get_base(UnitStats.StatKey.HP)
	)
	
	get_tree().paused = true
	if field_map.map_start_event != null and params.play_starting_event:
		await get_tree().process_frame
		await field_ui.play_dialogue(field_map.map_start_event, {
			PlayParagraphDialogueEvent.ParagraphEventKeys.FORMAT_VARS : get_global_format_vars()
		})
	
	get_tree().paused = false
	hero_character.set_process(true)


func transition_to_map(path: String, params: MapLoadParams) -> void:
	hero_character.set_process(false)
	hero_character.cancel_move()
	
	get_tree().paused = true
	
	var transition_sfx: String = "stairs"
	if params.transition_sound != "":
		transition_sfx = params.transition_sound
	AudioManager.play_sfx(transition_sfx)
	
	field_ui.hide_hud()
	await MenuStack.clear_menu_stack()
	
	await GlobalVisuals.fade_out()
	
	field_ui.dialogue_window.visible = false
	field_ui.command_window.visible = false
	
	await load_map(path, params)
	
	get_tree().paused = false


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
			PlayParagraphDialogueEvent.ParagraphEventKeys.FORMAT_VARS : get_global_format_vars(),
			"shop_interface": field_ui.shop_interface,
			"map": field_map,
			"map_controller": self
		})
		close_command_window()
		return
	
	var event: MapEvent = field_map.find_event(hero_character.get_facing_tile_position())
	if event != null and event.talk_event != null:
		var params: Dictionary = {
			PlayParagraphDialogueEvent.ParagraphEventKeys.FORMAT_VARS : get_global_format_vars(),
			"map": field_map,
			"map_controller": self,
			"default_bgm": field_map.map_bgm
		}
		await field_ui.play_dialogue(event.talk_event, params)
		close_command_window()
		return
	
	await field_ui.play_dialogue(talk_default_dialogue)
	close_command_window()


func on_take_selected() -> void:
	await MenuStack.pop_stack()
	
	var event: MapEvent = field_map.find_event(hero_character.position)
	if event != null and event.take_event != null:
		var params: Dictionary = {
			PlayParagraphDialogueEvent.ParagraphEventKeys.FORMAT_VARS : get_global_format_vars(),
			"map" : field_map,
			"map_controller": self
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
		await field_ui.play_dialogue(event.search_event, {
			PlayParagraphDialogueEvent.ParagraphEventKeys.FORMAT_VARS : [PlayerManager.hero.get_unit_name()],
			"map_controller": self,
			"map": field_map
		}, false)
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
		field_ui.show_item_window(
		on_item_data_selected,
		func ():
			await MenuStack.pop_stack()
			close_command_window()
	)
	else:
		await field_ui.play_dialogue(item_default_dialogue)
		close_command_window()


func on_item_data_selected(item: ItemData) -> void:
	var clean: bool = true
	if item.use_dialogue != null:
		await field_ui.play_dialogue(item.use_dialogue, {
			PlayParagraphDialogueEvent.ParagraphEventKeys.FORMAT_VARS: [PlayerManager.hero.get_unit_name()],
			"wait_for_continuation": false
		})
		clean = false
	
	var consumable_condition_eval: bool = true
	if item.consumable_condition != null:
		consumable_condition_eval = item.consumable_condition.evaluate(field_ui.dialogue_window, {
			"map_controller": self
		})
	if item.consumable and consumable_condition_eval:
		PlayerManager.hero.inventory.remove_item(item)
	await field_ui.play_dialogue(item.field_action, {
		PlayParagraphDialogueEvent.ParagraphEventKeys.FORMAT_VARS: [PlayerManager.hero.get_unit_name()],
		"map_controller": self,
		"default_bgm": field_map.map_bgm
	}, clean)
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


func on_stairs_selected() -> void:
	await MenuStack.pop_stack()
	var event: MapEvent = field_map.find_event(hero_character.position)
	if event != null and event.stairs_event != null:
		close_command_window()
		field_ui.hide_hud()
		await field_ui.play_dialogue(event.stairs_event, {
			"wait_for_continuation": false,
			"map_controller": self,
			"make_window_visible": false
		}, false)
	else:
		await field_ui.play_dialogue(default_stairs_dialogue)
		close_command_window()


func on_spell_selected() -> void:
	await MenuStack.pop_stack()
	if PlayerManager.hero.spells.size() > 0:
		field_ui.show_spell_window(
		on_spell_data_selected,
		func ():
			await MenuStack.pop_stack()
			close_command_window()
	)
	else:
		await field_ui.play_dialogue(spell_default_dialogue, {
			PlayParagraphDialogueEvent.ParagraphEventKeys.FORMAT_VARS: [PlayerManager.hero.get_unit_name()],
			"map_controller": self
		})
		close_command_window()


func on_spell_data_selected(spell: SpellData) -> void:
	var spell_sequence: SequenceDialogueEvent = SequenceDialogueEvent.new()
	
	if PlayerManager.hero.stats.get_stat(UnitStats.StatKey.MP) >= spell.mp_cost:
		spell_sequence.events.append(GeneralDialogueProvider.get_dialogue(GeneralDialogueProvider.DialogueID.BattleChantSpell))
		
		var sfx: PlaySFXDialogueEvent = PlaySFXDialogueEvent.new()
		sfx.sfx_key = "spell"
		sfx.wait_for_sfx = false
		spell_sequence.events.append(sfx)
		
		var effect: PlayEffectDialogueEvent = PlayEffectDialogueEvent.new()
		effect.effect = PlayEffectDialogueEvent.EffectKey.SPELL
		spell_sequence.events.append(effect)
		
		var mp_spend: ChangeHeroStatsDialogueEvent = ChangeHeroStatsDialogueEvent.new()
		mp_spend.key = ChangeHeroStatsDialogueEvent.OperationKey.MODIFY_MP
		mp_spend.min_val = -spell.mp_cost
		spell_sequence.events.append(mp_spend)
		
		if spell.field_effect != null:
			spell_sequence.events.append(spell.field_effect)
		else:
			spell_sequence.events.append(non_field_spell_dialogue)
	else:
		spell_sequence.events.append(
			GeneralDialogueProvider.get_dialogue(GeneralDialogueProvider.DialogueID.BattleLowMP)
		)
	
	await field_ui.play_dialogue(
		spell_sequence,
		{
			PlayParagraphDialogueEvent.ParagraphEventKeys.FORMAT_VARS : [PlayerManager.hero.get_unit_name(), spell.spell_name],
			"map_controller": self
		}
	)
	close_command_window()


func on_move_finished() -> void:
	PlayerManager.hero.on_step()
	
	var out_event: DialogueEvent = field_map.out_of_bounds_event
	if out_event != null and field_map.is_out_of_bounds(hero_character.position):
		await field_ui.play_dialogue(out_event, {
			"make_window_visible": false,
			"map_controller": self
		})
		return
	
	var event: MapEvent = field_map.find_event(hero_character.position)
	if event != null and event.step_event != null:
		await field_ui.play_dialogue(event.step_event, {
			"wait_for_continuation": false,
			"map_controller": self,
			"make_window_visible": false
		})
		return
	
	var damage: int = field_map.get_tile_damage(hero_character.position)
	if damage > 0:
		get_tree().paused = true
		var effect_dict: Dictionary = damage_effect_dict.get(damage, {})
		PlayerManager.hero.deal_damage(damage)
		AudioManager.play_sfx(effect_dict.get("sfx", "tile_hit"))
		await (effect_dict.get("effect", GlobalVisuals.map_hurt_effect) as Callable).call()
		GlobalVisuals.determine_ui_colors(
			PlayerManager.hero.stats.get_stat(UnitStats.StatKey.HP),
			PlayerManager.hero.stats.get_base(UnitStats.StatKey.HP)
		)
		if PlayerManager.hero.is_dead():
			await AudioManager.play_bgm_one_shot("defeat")
			await field_ui.play_dialogue(
				GeneralDialogueProvider.get_dialogue(GeneralDialogueProvider.DialogueID.BattlePlayerDeath)
			)
			get_tree().quit()
			return
		get_tree().paused = false
	
	var zone: EncounterZone = field_map.get_encounter_zone(hero_character.position)
	if zone != null:
		var tile_id: EncounterChanceEntry.TileBattleID = field_map.get_tile_battle_id(hero_character.position)
		var encounter: EncounterData = zone.roll_for_battle(tile_id)
		if encounter != null:
			start_battle_from_zone(encounter, zone)


func start_battle_from_zone(encounter: EncounterData, zone: EncounterZone) -> void:
	var config: BattleConfig = BattleConfig.new()
	config.field_bgm = field_map.map_bgm
	config.battle_bg = zone.battle_bg
	config.is_dark = zone.is_dark
	start_battle(encounter, config)


func start_battle(encounter: EncounterData, config: BattleConfig) -> void:
	field_ui.visible = false
	get_tree().paused = true
	battle_controller.set_visibility(true)
	battle_controller.position.x = hero_character.position.x - (8*17)
	battle_controller.position.y = hero_character.position.y - (7*16)
	battle_controller.start_battle(encounter, config)


func on_battle_finished(status: BattleController.BattleEndStatus, config: BattleConfig) -> void:
	match status:
		BattleController.BattleEndStatus.VICTORY:
			if config.victory_event != null:
				await field_ui.play_dialogue(config.victory_event, {
					"map": field_map,
					"map_controller": self
				})
		BattleController.BattleEndStatus.RUN:
			if config.run_event != null:
				await field_ui.play_dialogue(config.run_event, {
					"map_controller": self
				})
		_:
			pass
	back_from_battle()


func back_from_battle() -> void:
	get_tree().paused = false
	field_ui.visible = true
	battle_controller.set_visibility(false)


func get_global_format_vars() -> Array:
	return [
		PlayerManager.hero.get_unit_name(),
		PlayerManager.get_exp_for_next_level()
	]

func illuminate(strength: int, battery: int = 0) -> void:
	hero_character.illuminate(strength, battery)


func initialize_darkness() -> void:
	hero_character.darkness_layer.initialize()
