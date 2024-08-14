extends DialogueEvent
class_name PlayEffectDialogueEvent

enum EffectKey {
	SPELL
}

@export var effect: EffectKey

func execute(window: DialogueWindow, _params: Dictionary) -> void:
	await window.get_tree().process_frame
	match effect:
		EffectKey.SPELL:
			await GlobalVisuals.spell_effect()
