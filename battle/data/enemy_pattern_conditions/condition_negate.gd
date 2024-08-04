extends EnemyPatternCondition
class_name ConditionNegate

@export var condition: EnemyPatternCondition

func evaluate(user: EnemyUnit, target: BattleUnit) -> bool:
	return not condition.evaluate(user, target)
