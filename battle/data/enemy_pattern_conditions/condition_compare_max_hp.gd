extends EnemyPatternCondition
class_name ConditionCompareMaxHP

enum ComparisonType {
	LESS_THAN
}

@export var comparison_type: ComparisonType = ComparisonType.LESS_THAN
@export var multiplier: float = 1.0

func evaluate(user: EnemyUnit, _target: BattleUnit) -> bool:
	match comparison_type:
		ComparisonType.LESS_THAN:
			return user.stats.hp < floor(float(user.stats.max_hp) * multiplier)
		_:
			return false
