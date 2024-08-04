extends Resource
class_name ActionData

enum TargetType {
	SELF, ENEMY
}

@export var target_type: TargetType
@export var spell_effects: Array[SpellEffect]


func get_target(user: BattleUnit, user_enemy: BattleUnit) -> BattleUnit:
	match target_type:
		TargetType.SELF:
			return user
		TargetType.ENEMY:
			return user_enemy
		_:
			return null
