extends Resource
class_name BGMEntry

enum BGMKey {
	BattleBGM, Overworld, Victory, Defeat,
	FairyFlute, BattleReprise, LevelUp
}

@export var key: BGMKey
@export var bgm: AudioStream
