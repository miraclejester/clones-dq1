extends RefCounted
class_name MapMoveParams

var skip_steps: bool
var skip_oob: bool
var skip_damage: bool

func _init(st: bool = false, oob: bool = false, d: bool = false) -> void:
	skip_steps = st
	skip_oob = oob
	skip_damage = d
