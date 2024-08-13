extends DialogueEvent
class_name WaitForAnyInputDialogueEvent

var valid_inputs: Array[String] = ["up", "down", "left", "right", "A", "B"]

func execute(window: DialogueWindow, _params: Dictionary) -> void:
	window.visible = false
	await window.get_tree().process_frame
	var finished: bool = false
	while not finished:
		for input in valid_inputs:
			if Input.is_action_just_pressed(input):
				finished = true
				break
		await window.get_tree().process_frame
	await window.get_tree().process_frame
	window.visible = true
