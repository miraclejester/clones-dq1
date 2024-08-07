extends Resource
class_name BGMEntry

enum BGMKey {
	BattleBGM, Overworld
}

@export var key: BGMKey
@export var bgm: AudioStream
