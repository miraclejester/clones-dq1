extends Control
class_name PlayerHUD

@export var debug_hero: HeroUnit
@export var is_debug: bool = false

@onready var player_name: Label = %PlayerName
@onready var level_text: Label = %LevelText
@onready var hp_text: Label = %HPText
@onready var mp_text: Label = %MPText
@onready var gold_text: Label = %GoldText
@onready var exp_text: Label = %ExpText

var hero: HeroUnit

func _ready() -> void:
	debug_hero.hero_name = "Debug"
	if is_debug:
		set_hero(debug_hero)


func _process(_delta: float) -> void:
	if (is_debug):
		debug_update()


func set_hero(h: HeroUnit) -> void:
	hero = h
	player_name.text = hero.hero_name.substr(0, 4)
	update_from_hero()


func update_from_hero() -> void:
	on_hp_changed(hero.stats.hp)
	on_mp_changed(hero.stats.mp)
	on_level_changed(hero.level)
	on_gold_changed(hero.gold)
	on_exp_changed(hero.experience)


func on_hp_changed(val: int) -> void:
	hp_text.text = "%d" % val


func on_mp_changed(val: int) -> void:
	mp_text.text = "%d" % val


func on_level_changed(val: int) -> void:
	level_text.text = "%d" % val


func on_gold_changed(val: int) -> void:
	gold_text.text = "%d" % val


func on_exp_changed(val: int) -> void:
	exp_text.text = "%d" % val


func debug_update() -> void:
	if Input.is_action_just_pressed("right"):
		debug_hero.set_hp(debug_hero.stats.hp + 1)
	elif Input.is_action_just_pressed("left"):
		debug_hero.set_hp(debug_hero.stats.hp - 1)
	
	if Input.is_action_just_pressed("A"):
		debug_hero.add_gold(1)
	elif Input.is_action_just_pressed("B"):
		debug_hero.add_gold(-1)
	
	if Input.is_action_just_pressed("select"):
		debug_hero.add_exp(1)
	
	if Input.is_action_just_pressed("start"):
		debug_hero.level_up()
