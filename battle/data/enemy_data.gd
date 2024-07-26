extends Resource
class_name EnemyData

enum BattlePositionGroup {
	SLIME, DRACKY, GHOST,
	SORCERER, SCORPION, BEHOLDER,
	SNAIL, SKELETON, WOLFMAN,
	WYVERN, KNIGHT, GOLEM,
	DRAGON, DRAGONLORD, FINAL_DRAGONLORD
}

@export var enemy_name: String
@export var texture: Texture2D
@export var stats: EnemyStatData
@export var initiative_group: int
@export var position_group: BattlePositionGroup


func get_position_from_group() -> Vector2:
	match position_group:
		BattlePositionGroup.SLIME:
			return Vector2(137, 113)
		_:
			return Vector2.ZERO
