extends EnemyPatternCondition
class_name ConditionHasStatus

@export var condition: BattleUnit.StatusEffect

func evaluate(_user: EnemyUnit, target: BattleUnit) -> bool:
	return target.has_status(condition)
