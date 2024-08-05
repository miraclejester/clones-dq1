extends Node
class_name UnitStats

enum StatKey {
	STR, AGI, MAX_HP, MAX_MP,
	HP, MP, LVL
}

signal hp_changed(val: int)
signal mp_changed(val: int)

var GET_STAT_DICT: Dictionary = {
	StatKey.STR : get_strength,
	StatKey.HP : get_hp,
	StatKey.MAX_HP : get_max_hp
}

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


func get_stat(key: StatKey) -> int:
	return (GET_STAT_DICT.get(key, func(): return 0) as Callable).call()


func get_strength() -> int:
	return strength


func set_strength(val: int) -> void:
	strength = val

func set_agility(val: int) -> void:
	agility = val


func get_hp() -> int:
	return hp


func get_max_hp() -> int:
	return max_hp


func set_max_hp(val: int) -> void:
	max_hp = val
	hp = clampi(hp, 0, max_hp)

func set_max_mp(val: int) -> void:
	max_mp = val
	mp = clampi(mp, 0, max_mp)
