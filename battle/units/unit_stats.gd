extends Node
class_name UnitStats

@export var stat_scene: PackedScene

enum StatKey {
	STR, AGI, HP, MP
}

signal hp_changed(val: int)
signal mp_changed(val: int)

var stat_dict: Dictionary = {}


func _ready() -> void:
	create_stat(StatKey.STR)
	create_stat(StatKey.AGI)
	create_stat(StatKey.HP)
	create_stat(StatKey.MP)


func create_stat(key: StatKey) -> void:
	var s: Stat = stat_scene.instantiate() as Stat
	add_child(s)
	stat_dict[key] = s


func get_stat(key: StatKey) -> int:
	var stat: Stat = stat_dict.get(key, null) as Stat
	if stat == null:
		return 0
	return stat.current_value


func set_stat(key: StatKey, val: int) -> void:
	var stat: Stat = stat_dict.get(key, null) as Stat
	if stat != null:
		stat.set_current_value(val)


func modify_stat(key: StatKey, amount: int) -> void:
	var stat: Stat = stat_dict.get(key, null) as Stat
	if stat != null:
		stat.set_current_value(stat.current_value + amount)


func get_base(key: StatKey) -> int:
	var stat: Stat = stat_dict.get(key, null) as Stat
	if stat == null:
		return 0
	return stat.value


func set_base(key: StatKey, val: int, go_max: bool = true) -> void:
	var stat: Stat = stat_dict.get(key, null) as Stat
	if stat != null:
		stat.set_value(val)
		if go_max:
			maximize(key)


func maximize(key: StatKey) -> void:
	var stat: Stat = stat_dict.get(key, null) as Stat
	if stat != null:
		stat.set_current_value(stat.value)
