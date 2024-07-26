extends Node
class_name UnitStats

signal hp_changed(val: int)
signal mp_changed(val: int)

var strength: int
var agility: int
var max_hp: int
var max_mp: int

var hp: int:
	get:
		return hp
	set(value):
		hp = clampi(value, 0, max_hp)
		hp_changed.emit(hp)
var mp: int:
	get:
		return mp
	set(value):
		mp = clampi(value, 0, max_mp)
		mp_changed.emit(mp)

func set_strength(val: int) -> void:
	strength = val

func set_agility(val: int) -> void:
	agility = val

func set_max_hp(val: int) -> void:
	max_hp = val
	hp = clampi(hp, 0, max_hp)

func set_max_mp(val: int) -> void:
	max_mp = val
	mp = clampi(mp, 0, max_mp)
