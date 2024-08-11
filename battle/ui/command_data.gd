extends RefCounted
class_name CommandData

var text: String
var callback: Callable
var amount: int

func _init(t: String, c: Callable, a: int = 0) -> void:
	text = t
	callback = c
	amount = a
