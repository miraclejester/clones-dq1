extends Node

@export_dir var bgm_dir: String
@export_dir var sfx_dir: String

@onready var bgm_player: AudioStreamPlayer = %BGMPlayer
@onready var sfx_player: AudioStreamPlayer = %SFXPlayer


func _ready() -> void:
	sfx_player.play()


func play_bgm(key: String) -> void:
	var new_bgm: AudioStream = load_bgm(key)
	if new_bgm != bgm_player.stream:
		bgm_player.stop()
		bgm_player.stream = new_bgm
		bgm_player.play()
	elif key == "":
		bgm_player.stop()


func play_bgm_one_shot(key: String) -> void:
	play_bgm(key)
	await bgm_player.finished


func load_bgm(key: String) -> AudioStream:
	return load("%s/%s.ogg" % [bgm_dir, key]) as AudioStream


func play_sfx(key: String) -> void:
	var poly: AudioStreamPlaybackPolyphonic = sfx_player.get_stream_playback() as AudioStreamPlaybackPolyphonic
	var stream_id: int = poly.play_stream(load_sfx(key))
	while poly.is_stream_playing(stream_id):
		await get_tree().process_frame


func load_sfx(key: String) -> AudioStream:
	return load("%s/sfx_%s.wav" % [sfx_dir, key]) as AudioStream
