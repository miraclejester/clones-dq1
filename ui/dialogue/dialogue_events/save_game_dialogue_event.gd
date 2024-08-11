extends DialogueEvent
class_name SaveGameDialogueEvent

func execute(window: DialogueWindow, _params: Dictionary) -> void:
	GameDataManager.save_game()
	await window.get_tree().process_frame
