extends Resource
class_name SpellData

enum TargetType {
	SELF, ENEMY
}


@export var spell_name: String
@export var target_type: TargetType
@export var mp_cost: int
@export var spell_effects: Array[SpellEffect]
