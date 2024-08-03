extends Node2D
class_name BattleController

signal battle_finished()

@export var enemy_data: EnemyData

@onready var battle = $Battle
@onready var battle_bg: BattleBG = $BattleBG
@onready var enemy_controller: EnemyController = $Enemy
@onready var battle_ui: BattleUI = $BattleUI

var battle_update_queue: Array[BattleUpdate] = []


func _ready() -> void:
	battle_ui.fight_selected.connect(fight_selected)
	battle_ui.spell_selected.connect(spell_selected)
	battle_ui.run_selected.connect(run_selected)
	
	battle_ui.spell_data_selected.connect(spell_selected_from_menu)
	battle_ui.spell_cancelled.connect(spell_menu_cancelled)
	start_battle()


func start_battle() -> void:
	var hero_state: HeroState = HeroState.new()
	hero_state.hero_name = "Erdrick"
	hero_state.hp = 30
	hero_state.mp = 12
	hero_state.level = 4
	
	battle_update_queue = []
	battle.init_battle(hero_state, enemy_data)
	enemy_controller.set_data(enemy_data)
	battle_ui.initialize()
	battle_ui.set_hero_data(battle.hero)
	battle_ui.determine_ui_colors(hero_state.hp, battle.hero.stats.max_hp)
	
	await battle_bg.start_appear_animation()
	
	enemy_controller.visible = true
	await enemy_controller.play_appear_animation().animation_finished
	battle_ui.show_dialogue_window()
	await battle_ui.show_line(
		GeneralDialogueProvider.DialogueID.BattleStart,
		[enemy_data.enemy_name]
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


func spell_selected_from_menu(data: SpellData) -> void:
	await battle_ui.hide_spell_window()
	battle_ui.hide_command_window()
	if battle.hero.stats.mp < data.mp_cost:
		await battle_ui.show_line(GeneralDialogueProvider.DialogueID.BattleLowMP)
		await battle_ui.show_newline()
		battle.do_turn()
	else:
		battle.player_spell(data)
	process_updates()


func spell_menu_cancelled() -> void:
	await battle_ui.hide_spell_window()
	battle_ui.hide_command_window()
	await battle_ui.show_newline()
	battle.do_turn()
	process_updates()


func finish_battle() -> void:
	battle_finished.emit()
