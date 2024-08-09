extends DialogueEvent
class_name PlaySFXDialogueEvent

@export var sfx_key: SFXEntry.SFXKey
@export var wait_for_sfx: bool = false

func execute(window: DialogueWindow, _params: Dictionary) -> void:
	await window.get_tree().process_frame
	
	if wait_for_sfx:
		await AudioManager.play_sfx(sfx_key)
	else:
		AudioManager.play_sfx(sfx_key)
