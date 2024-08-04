extends Resource
class_name EnemyPatternEntry

@export var chance: float
@export var condition: EnemyPatternCondition
@export var action: ActionData

func roll(user: EnemyUnit, target: BattleUnit) -> bool:
	return condition.evaluate(user, target) and randf_range(0.0, 1.0) < chance
