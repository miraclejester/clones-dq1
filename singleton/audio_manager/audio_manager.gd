extends Node

@export var bgms: Array[BGMEntry]

@onready var bgm_player: AudioStreamPlayer = %BGMPlayer

var bgm_dict: Dictionary = {} #BGMKey to AudioStream


func _ready() -> void:
	for entry in bgms:
		bgm_dict[entry.key] = entry.bgm
	play_bgm(BGMEntry.BGMKey.BattleBGM)


func play_bgm(key: BGMEntry.BGMKey) -> void:
	bgm_player.stop()
	bgm_player.stream = bgm_dict.get(key, null)
	bgm_player.play()
	
