extends RefCounted
class_name CommandData

var text: String
var callback: Callable
var amount: int
var multiline: bool
var override_moves: Dictionary

func _init(t: String, c: Callable, a: int = 0, m: bool = false, o: Dictionary = {}) -> void:
	text = t
	callback = c
	amount = a
	multiline = m
	override_moves = o
