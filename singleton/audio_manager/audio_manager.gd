extends Node

@export var bgms: Array[BGMEntry]
@export var sfxs: Array[SFXEntry]

@onready var bgm_player: AudioStreamPlayer = %BGMPlayer
@onready var sfx_player: AudioStreamPlayer = %SFXPlayer

var bgm_dict: Dictionary = {} #BGMKey to AudioStream
var sfx_dict: Dictionary = {} #SFXKey to AudioStream


func _ready() -> void:
	for entry in bgms:
		bgm_dict[entry.key] = entry.bgm
	for entry in sfxs:
		sfx_dict[entry.key] = entry.sfx


func play_bgm(key: BGMEntry.BGMKey) -> void:
	var new_bgm: AudioStream = bgm_dict.get(key, null)
	if new_bgm != bgm_player.stream:
		bgm_player.stop()
		bgm_player.stream = bgm_dict.get(key, null)
		bgm_player.play()


func play_bgm_one_shot(key: BGMEntry.BGMKey) -> void:
	play_bgm(key)
	await bgm_player.finished


func play_sfx(key: SFXEntry.SFXKey) -> void:
	sfx_player.stop()
	sfx_player.stream = sfx_dict.get(key, null)
	sfx_player.play()
