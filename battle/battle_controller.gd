extends Node2D
class_name BattleController

signal battle_finished(status: BattleEndStatus, config: BattleConfig)

enum BattleEndStatus {
	VICTORY, DEFEAT, RUN
}

@onready var battle = $Battle
@onready var battle_bg: BattleBG = $BattleBG
@onready var enemy_controller: EnemyController = %Enemy
@onready var battle_ui: BattleUI = $BattleUI
@onready var dragonlord_layer: CanvasLayer = $DragonlordLayer
@onready var darkness: Sprite2D = %Darkness



var battle_update_queue: Array[BattleUpdate] = []
var hero: HeroUnit
var reprise_key: String
var show_spoils: bool = true
var encounter_data: EncounterData
var config: BattleConfig
var running: bool = false


func _ready() -> void:
	battle_ui.fight_selected.connect(fight_selected)
	battle_ui.spell_selected.connect(spell_selected)
	battle_ui.run_selected.connect(run_selected)
	battle_ui.item_selected.connect(item_selected)
	battle_ui.visible = false
	darkness.visible = false


func start_battle(ec: EncounterData, c: BattleConfig) -> void:
	running = true
	
	encounter_data = ec
	config = c
	
	hero = PlayerManager.hero
	battle_update_queue = []
	battle.init_battle(encounter_data.enemy)
	enemy_controller.set_data(encounter_data.enemy)
	battle_ui.initialize()
	battle_ui.set_hero_data(battle.hero)
	GlobalVisuals.determine_ui_colors(
		hero.stats.get_stat(UnitStats.StatKey.HP),
		hero.stats.get_base(UnitStats.StatKey.HP)
	)
	
	show_spoils = encounter_data.show_spoils
	
	if encounter_data.use_dragonlord_layer:
		remove_child(enemy_controller)
		dragonlord_layer.add_child(enemy_controller)
	enemy_controller.visible = false
	
	AudioManager.play_bgm(encounter_data.bgm_key)
	reprise_key = encounter_data.reprise_key
	
	battle_bg.set_bg_texture(config.battle_bg)
	await battle_bg.start_appear_animation()
	darkness.visible = config.is_dark
	
	enemy_controller.visible = true
	var callables: Array[Callable] = []
	callables.append(enemy_controller.play_appear_animation)
	if encounter_data.pre_battle_event != null:
		callables.append(battle_ui.play_dialogue.bind(encounter_data.pre_battle_event))
	await ParallelPromise.new(callables).run_all()
	
	
	battle_ui.show_dialogue_window()
	if encounter_data.intro_dialogue != null:
		await battle_ui.show_line_from_data(
			encounter_data.intro_dialogue,
			[encounter_data.enemy.enemy_name]
		)
	else:
		await battle_ui.show_line(
			GeneralDialogueProvider.DialogueID.BattleStart,
			[encounter_data.enemy.enemy_name]
		)
	await battle_ui.show_newline()
	battle_ui.show_hud()
	
	battle.start_battle()
	process_updates()


func process_updates() -> void:
	while battle.updates.size() > 0:
		var update: BattleUpdate = battle.updates.pop_front()
		await update.execute(self)


func ask_command() -> void:
	await battle_ui.show_line(GeneralDialogueProvider.DialogueID.BattleCommand)
	await battle_ui.show_newline()
	battle_ui.show_command_window(command_menu_cancelled)


func fight_selected() -> void:
	battle_ui.hide_command_window()
	await MenuStack.pop_stack()
	battle.player_fight()
	process_updates()


func run_selected() -> void:
	battle_ui.hide_command_window()
	await MenuStack.pop_stack()
	battle.player_run()
	process_updates()


func spell_selected() -> void:
	if battle.hero.spells.size() == 0:
		battle_ui.hide_command_window()
		await MenuStack.pop_stack()
		await NoSpellBattleUpdate.from_data(battle.hero.get_unit_name()).execute(self)
		battle.do_turn()
		process_updates()
	else:
		battle_ui.show_spell_window(spell_selected_from_menu, spell_menu_cancelled)


func item_selected() -> void:
	if hero.inventory.stack_count() == 0:
		battle_ui.hide_command_window()
		await MenuStack.pop_stack()
		await NoItemBattleUpdate.new().execute(self)
		battle.do_turn()
		process_updates()
	else:
		battle_ui.refresh_inventory(hero)
		battle_ui.show_item_window(item_selected_from_menu, item_menu_cancelled)
		


func spell_selected_from_menu(data: SpellData) -> void:
	await MenuStack.pop_stack()
	battle_ui.hide_spell_window()
	await MenuStack.pop_stack()
	battle_ui.hide_command_window()
	if battle.hero.stats.get_stat(UnitStats.StatKey.MP) < data.mp_cost:
		await battle_ui.show_line(GeneralDialogueProvider.DialogueID.BattleLowMP)
		await battle_ui.show_newline()
		battle.do_turn()
	else:
		battle.player_spell(data)
	process_updates()


func item_selected_from_menu(data: ItemData) -> void:
	await MenuStack.pop_stack()
	battle_ui.hide_item_window()
	await MenuStack.pop_stack()
	battle_ui.hide_command_window()
	if (not data.battle_action) or (data.battle_action.spell_effects.size() == 0):
		await battle_ui.show_line(GeneralDialogueProvider.DialogueID.BattleCannotUseItem)
		await battle_ui.show_newline()
		battle.do_turn()
	else:
		if data.consumable:
			hero.inventory.remove_item(data)
		battle.player_item(data)
	process_updates()


func spell_menu_cancelled() -> void:
	battle_ui.hide_spell_window()
	await MenuStack.pop_stack()
	battle_ui.hide_command_window()
	await MenuStack.pop_stack()
	battle.do_turn()
	process_updates()


func item_menu_cancelled() -> void:
	battle_ui.hide_item_window()
	await MenuStack.pop_stack()
	battle_ui.hide_command_window()
	await MenuStack.pop_stack()
	await battle_ui.show_newline()
	battle.do_turn()
	process_updates()


func command_menu_cancelled() -> void:
	await MenuStack.pop_stack()
	battle.do_turn()
	process_updates()


func finish_battle(status: BattleEndStatus) -> void:
	running = false
	await get_tree().process_frame
	darkness.visible = false
	if config.wait_for_end_dialogue:
		await battle_ui.wait_for_dialogue_continuation(encounter_data.after_victory_event != null)
	if status == BattleEndStatus.VICTORY and encounter_data.after_victory_event != null:
		await battle_ui.play_dialogue(encounter_data.after_victory_event)
	battle_finished.emit(status, config)


func reprise_battle_bgm() -> void:
	AudioManager.play_bgm(reprise_key)


func player_hurt_shake() -> void:
	if encounter_data.shake_on_hit:
		await GlobalVisuals.player_hurt_shake()
	else:
		await get_tree().create_timer(0.1).timeout


func set_visibility(v: bool) -> void:
	visible = v
	battle_ui.visible = v
