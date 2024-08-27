extends FormatVarProvider
class_name NextLevelExpFormatVarProvider

func get_format_var(_params: Dictionary = {}) -> Variant:
	return PlayerManager.get_exp_for_next_level()
