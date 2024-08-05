extends Node
class_name Stat

var value: int = 0
var current_value: int = 0


func set_current_value(v: int) -> void:
	current_value = clampi(v, 0, value)


func set_value(v: int) -> void:
	value = v
	if current_value > value:
		current_value = value
