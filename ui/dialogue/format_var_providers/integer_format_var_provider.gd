extends FormatVarProvider
class_name IntegerFormatVarProvider

@export var value: int

func get_format_var(params: Dictionary = {}) -> Variant:
	return params.get("integer_provider_value", value)
