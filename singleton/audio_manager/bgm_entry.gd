extends Resource
class_name BGMEntry

enum BGMKey {
	BattleBGM, Overworld, Victory, Defeat,
	FairyFlute, BattleReprise, LevelUp, SilverHarp,
	None, FinalBattle
}

@export var key: BGMKey
@export var bgm: AudioStream
