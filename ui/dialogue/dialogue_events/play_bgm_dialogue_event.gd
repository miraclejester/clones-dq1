extends DialogueEvent
class_name PlayBGMDialogueEvent

@export var bgm_key: String
@export var wait_for_bgm: bool = false

func execute(window: DialogueWindow, params: Dictionary) -> void:
	await window.get_tree().process_frame
	
	var key: String = bgm_key
	if bgm_key == "":
		key = params.get("default_bgm", "")
	
	if wait_for_bgm:
		await AudioManager.play_bgm_one_shot(key)
	else:
		AudioManager.play_bgm(key)
