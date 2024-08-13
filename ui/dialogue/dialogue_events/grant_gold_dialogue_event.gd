extends DialogueEvent
class_name GrantGoldDialogueEvent

@export var amount: int

func execute(window: DialogueWindow, params: Dictionary) -> void:
	await window.get_tree().process_frame
	PlayerManager.hero.add_gold(params.get("grant_gold_amount", amount))
