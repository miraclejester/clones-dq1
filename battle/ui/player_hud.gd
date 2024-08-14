extends Control
class_name PlayerHUD

enum HUDStatKey {
	HP, MP, LVL, GP, XP
}

@onready var player_name: Label = %PlayerName
@onready var level_text: Label = %LevelText
@onready var hp_text: Label = %HPText
@onready var mp_text: Label = %MPText
@onready var gold_text: Label = %GoldText
@onready var exp_text: Label = %ExpText

var hero: HeroUnit


func set_hero(h: HeroUnit, set_signals: bool = false) -> void:
	hero = h
	player_name.text = hero.hero_name.substr(0, 4)
	update_from_hero()
	if set_signals:
		hero.hp_changed.connect(on_hp_changed)
		hero.mp_changed.connect(on_mp_changed)
		hero.level_changed.connect(on_level_changed)
		hero.gold_changed.connect(on_gold_changed)
		hero.exp_changed.connect(on_exp_changed)


func update_from_hero() -> void:
	on_hp_changed(hero.stats.get_stat(UnitStats.StatKey.HP))
	on_mp_changed(hero.stats.get_stat(UnitStats.StatKey.MP))
	on_level_changed(hero.level)
	on_gold_changed(hero.gold)
	on_exp_changed(hero.experience)


func update_stat(key: HUDStatKey, val: int) -> void:
	match key:
		HUDStatKey.HP:
			on_hp_changed(val)
		HUDStatKey.MP:
			on_mp_changed(val)
		HUDStatKey.LVL:
			on_level_changed(val)
		HUDStatKey.GP:
			on_gold_changed(val)
		HUDStatKey.XP:
			on_exp_changed(val)


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
