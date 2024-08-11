extends RefCounted
class_name SaveDataEntry

var key: String
var data: Dictionary

func _init(k: String, d: Dictionary) -> void:
	key = k
	data = d
