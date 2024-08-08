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
	EnemyData.BattlePositionGroup.DRACKY: Vector2(136, 105),
	EnemyData.BattlePositionGroup.GHOST: Vector2(136, 105),
	EnemyData.BattlePositionGroup.SORCERER: Vector2(135, 104),
	EnemyData.BattlePositionGroup.SCORPION: Vector2(138, 112),
	EnemyData.BattlePositionGroup.BEHOLDER: Vector2(138, 98),
	EnemyData.BattlePositionGroup.SNAIL: Vector2(136, 102),
	EnemyData.BattlePositionGroup.SKELETON: Vector2(134, 105),
	EnemyData.BattlePositionGroup.WOLFMAN: Vector2(136, 107),
	EnemyData.BattlePositionGroup.WYVERN: Vector2(133, 102),
	EnemyData.BattlePositionGroup.KNIGHT: Vector2(138, 103),
	EnemyData.BattlePositionGroup.GOLEM: Vector2(136, 105),
	EnemyData.BattlePositionGroup.DRAGON: Vector2(129, 105)
}

@export var enemy_name: String
@export var texture: Texture2D
@export var hurt_texture: Texture2D
@export var stats: EnemyStatData
@export var initiative_group: int
@export var position_group: BattlePositionGroup
@export var patterns: Array[EnemyPatternEntry]


func get_position_from_group() -> Vector2:
	return POSITION_GROUP_MAP.get(position_group, Vector2.ZERO)
