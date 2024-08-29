extends DialogueEvent
class_name ChangeSceneDialogueEvent

@export var target_scene: PackedScene

func execute(window: DialogueWindow, _params: Dictionary) -> void:
	await window.get_tree().process_frame
	window.get_tree().change_scene_to_packed(target_scene)
