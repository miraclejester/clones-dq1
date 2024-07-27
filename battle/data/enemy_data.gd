extends Resource
class_name EnemyData

enum BattlePositionGroup {
	SLIME, DRACKY, GHOST,
	SORCERER, SCORPION, BEHOLDER,
	SNAIL, SKELETON, WOLFMAN,
	WYVERN, KNIGHT, GOLEM,
	DRAGON, DRAGONLORD, FINAL_DRAGONLORD
}

const POSITION_GROUP_MAP: Dictionary = {
	EnemyData.BattlePositionGroup.SLIME: Vector2(137, 106),
	EnemyData.BattlePositionGroup.DRACKY: Vector2(136, 105)
}

@export var enemy_name: String
@export var texture: Texture2D
@export var stats: EnemyStatData
@export var initiative_group: int
@export var position_group: BattlePositionGroup
@export var appear_palette: Texture2D


func get_position_from_group() -> Vector2:
	return POSITION_GROUP_MAP.get(position_group, Vector2.ZERO)
