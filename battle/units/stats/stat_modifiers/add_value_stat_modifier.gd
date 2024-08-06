extends StatModifier
class_name AddValueStatModifier

@export var value: int

func modify(orig: int) -> int:
	return orig + value
