extends DialogueEvent
class_name PlayBGMDialogueEvent

@export var bgm_key: String
@export var wait_for_bgm: bool = false

func execute(window: DialogueWindow, _params: Dictionary) -> void:
	await window.get_tree().process_frame
	
	if wait_for_bgm:
		await AudioManager.play_bgm_one_shot(bgm_key)
	else:
		AudioManager.play_bgm(bgm_key)
