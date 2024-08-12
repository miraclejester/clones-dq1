extends RefCounted
class_name CommandData

var text: String
var callback: Callable
var amount: int
var multiline: bool

func _init(t: String, c: Callable, a: int = 0, m: bool = false) -> void:
	text = t
	callback = c
	amount = a
	multiline = m
