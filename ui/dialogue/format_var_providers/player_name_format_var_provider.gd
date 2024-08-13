extends FormatVarProvider
class_name PlayerNameFormatVarProvider

func get_format_var() -> Variant:
	return PlayerManager.hero.get_unit_name()
