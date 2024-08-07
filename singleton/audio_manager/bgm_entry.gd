extends Resource
class_name BGMEntry

enum BGMKey {
	BattleBGM, Overworld, Victory, Defeat,
	FairyFlute, BattleReprise
}

@export var key: BGMKey
@export var bgm: AudioStream
