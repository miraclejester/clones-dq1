extends DialogueEvent
class_name StartRandomBattleDialogueEvent

@export var encounters: Array[EncounterData]
@export var config: BattleConfig

func execute(window: DialogueWindow, params: Dictionary) -> void:
	await window.get_tree().process_frame
	window.auto_continue = true
	var controller: FieldMapController = params.get("map_controller") as FieldMapController
	controller.close_command_window(false)
	controller.start_battle(encounters.pick_random(), config)
