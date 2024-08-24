extends DialogueCondition
class_name PlayerBoolStatusDialogueCondition

enum PlayerCondition {
	IS_CURSED
}

@export var condition_to_check: PlayerCondition

func evaluate(_window: DialogueWindow, _params: Dictionary) -> bool:
	match condition_to_check:
		PlayerCondition.IS_CURSED:
			return PlayerManager.hero.is_cursed
		_:
			return true
