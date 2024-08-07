extends DialogueEvent
class_name PlaySFXDialogueEvent

@export var sfx_key: SFXEntry.SFXKey

func execute(window: DialogueWindow, _params: Dictionary) -> void:
	await window.get_tree().process_frame
	AudioManager.play_sfx(sfx_key)
