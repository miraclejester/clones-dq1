extends EventParamProvider
class_name RandomIntegerEventParamProvider

@export var min_value: int
@export var max_value: int


func get_param() -> Variant:
	return randi_range(min_value, max_value)
