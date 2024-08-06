extends Resource
class_name StatModifier

@export var target_stat: UnitStats.StatKey

func modify(orig: int) -> int:
	return orig
