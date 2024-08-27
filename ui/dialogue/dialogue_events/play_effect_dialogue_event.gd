extends DialogueEvent
class_name PlayEffectDialogueEvent

enum EffectKey {
	SPELL,
	RAINBOW_DROP
}

@export var effect: EffectKey
@export var wait_for_effect: bool = true

func execute(window: DialogueWindow, _params: Dictionary) -> void:
	await window.get_tree().process_frame
	var callable: Callable
	match effect:
		EffectKey.SPELL:
			callable = GlobalVisuals.spell_effect
		EffectKey.RAINBOW_DROP:
			callable = GlobalVisuals.play_rainbow_drop
	if wait_for_effect:
		await callable.call()
	else:
		callable.call()
