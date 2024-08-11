extends Node
class_name SaveDataHandler

var save_callable: Callable

func register_save_callable(c: Callable) -> void:
	save_callable = c

func get_save_data() -> SaveDataEntry:
	return save_callable.call() as SaveDataEntry
