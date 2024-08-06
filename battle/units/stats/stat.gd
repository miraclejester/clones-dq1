extends Node
class_name Stat

var value: int = 0
var current_value: int = 0
var modifiers: Array[StatModifier]


func set_current_value(v: int) -> void:
	current_value = clampi(v, 0, value)


func set_value(v: int) -> void:
	value = v
	if current_value > value:
		current_value = value


func get_current_value() -> int:
	var res: int = current_value
	for modifier in modifiers:
		res = modifier.modify(res)
	return res
