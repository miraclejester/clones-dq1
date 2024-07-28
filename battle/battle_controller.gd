extends Node2D
class_name BattleController

signal battle_update_finished()

@export var enemy_data: EnemyData

@onready var battle = $Battle
@onready var battle_bg: BattleBG = $BattleBG
@onready var enemy_controller: EnemyController = $Enemy
@onready var battle_ui: BattleUI = $BattleUI

var battle_update_queue: Array[BattleUpdate] = []


func _ready() -> void:
	battle_ui.fight_selected.connect(fight_selected)
	start_battle()


func start_battle() -> void:
	var hero_state: HeroState = HeroState.new()
	hero_state.hero_name = "Erdrick"
	hero_state.hp = 20
	hero_state.mp = 0
	hero_state.level = 3
	
	battle_update_queue = []
	battle.init_battle(hero_state, enemy_data)
	enemy_controller.set_data(enemy_data)
	battle_ui.initialize()
	battle_ui.set_hero_data(battle.hero)
	
	await battle_bg.start_appear_animation()
	
	enemy_controller.visible = true
	await enemy_controller.play_appear_animation().animation_finished
	battle_ui.show_dialogue_window()
	await battle_ui.show_battle_paragraph(
		GeneralDialogueProvider.DialogueID.BattleStart,
		[enemy_data.enemy_name]
	)
	battle_ui.show_hud()
	
	add_updates(battle.start_battle())
	process_updates()


func process_updates() -> void:
	while battle_update_queue.size() > 0:
		var update: BattleUpdate = battle_update_queue.pop_front()
		update.execute(self)
		await battle_update_finished


func add_updates(updates: Array[BattleUpdate]) -> void:
	battle_update_queue.append_array(updates)


func ask_command() -> void:
	await battle_ui.show_battle_paragraph(GeneralDialogueProvider.DialogueID.BattleCommand)
	battle_ui.show_command_window()


func fight_selected() -> void:
	battle_ui.hide_command_window()
	add_updates(battle.player_fight())
	process_updates()
