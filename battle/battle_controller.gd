extends Node2D
class_name BattleController

signal battle_finished()

@export var encounter_data: EncounterData

@onready var battle = $Battle
@onready var battle_bg: BattleBG = $BattleBG
@onready var enemy_controller: EnemyController = $Enemy
@onready var battle_ui: BattleUI = $BattleUI

var battle_update_queue: Array[BattleUpdate] = []
var hero: HeroUnit
var reprise_key: BGMEntry.BGMKey


func _ready() -> void:
	battle_ui.fight_selected.connect(fight_selected)
	battle_ui.spell_selected.connect(spell_selected)
	battle_ui.run_selected.connect(run_selected)
	battle_ui.item_selected.connect(item_selected)
	
	battle_ui.spell_data_selected.connect(spell_selected_from_menu)
	battle_ui.spell_cancelled.connect(spell_menu_cancelled)
	
	battle_ui.item_data_selected.connect(item_selected_from_menu)
	battle_ui.item_cancelled.connect(item_menu_cancelled)
	
	battle_ui.command_menu_cancelled.connect(command_menu_cancelled)
	start_battle()


func start_battle() -> void:
	hero = PlayerManager.hero
	battle_update_queue = []
	battle.init_battle(encounter_data.enemy)
	enemy_controller.set_data(encounter_data.enemy)
	battle_ui.initialize()
	battle_ui.set_hero_data(battle.hero)
	battle_ui.determine_ui_colors(
		hero.stats.get_stat(UnitStats.StatKey.HP),
		hero.stats.get_base(UnitStats.StatKey.HP)
	)
	
	AudioManager.play_bgm(encounter_data.bgm_key)
	reprise_key = encounter_data.reprise_key
	
	battle_bg.set_bg_texture(encounter_data.battle_bg)
	await battle_bg.start_appear_animation()
	
	enemy_controller.visible = true
	await enemy_controller.play_appear_animation().animation_finished
	battle_ui.show_dialogue_window()
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
	if battle.is_battle_finished():
		finish_battle()


func ask_command() -> void:
	await battle_ui.show_line(GeneralDialogueProvider.DialogueID.BattleCommand)
	await battle_ui.show_newline()
	battle_ui.show_command_window()


func fight_selected() -> void:
	battle_ui.hide_command_window()
	battle.player_fight()
	process_updates()


func run_selected() -> void:
	battle_ui.hide_command_window()
	battle.player_run()
	process_updates()


func spell_selected() -> void:
	if battle.hero.spells.size() == 0:
		battle_ui.hide_command_window()
		await NoSpellBattleUpdate.from_data(battle.hero.get_unit_name()).execute(self)
		battle.do_turn()
		process_updates()
	else:
		battle_ui.show_spell_window()


func item_selected() -> void:
	if hero.inventory.stack_count() == 0:
		battle_ui.hide_command_window()
		await NoItemBattleUpdate.new().execute(self)
		battle.do_turn()
		process_updates()
	else:
		battle_ui.refresh_inventory(hero)
		battle_ui.show_item_window()
		


func spell_selected_from_menu(data: SpellData) -> void:
	await battle_ui.hide_spell_window()
	battle_ui.hide_command_window()
	if battle.hero.stats.get_stat(UnitStats.StatKey.MP) < data.mp_cost:
		await battle_ui.show_line(GeneralDialogueProvider.DialogueID.BattleLowMP)
		await battle_ui.show_newline()
		battle.do_turn()
	else:
		battle.player_spell(data)
	process_updates()


func item_selected_from_menu(data: ItemData) -> void:
	await battle_ui.hide_item_window()
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
	await battle_ui.hide_spell_window()
	battle_ui.hide_command_window()
	await battle_ui.show_newline()
	battle.do_turn()
	process_updates()


func item_menu_cancelled() -> void:
	await battle_ui.hide_item_window()
	battle_ui.hide_command_window()
	await battle_ui.show_newline()
	battle.do_turn()
	process_updates()


func command_menu_cancelled() -> void:
	battle.do_turn()
	process_updates()


func finish_battle() -> void:
	battle_finished.emit()


func reprise_battle_bgm() -> void:
	AudioManager.play_bgm(reprise_key)
