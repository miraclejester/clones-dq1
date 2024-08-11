extends Resource
class_name BGMEntry

enum BGMKey {
	BattleBGM, Overworld, Victory, Defeat,
	FairyFlute, BattleReprise, LevelUp, SilverHarp,
	None, FinalBattle, TantegelThrone, Title
}

@export var key: BGMKey
@export var bgm: AudioStream
