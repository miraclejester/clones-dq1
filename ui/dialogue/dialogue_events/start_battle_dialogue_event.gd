extends DialogueEvent
class_name StartBattleDialogueEvent

@export var encounter: EncounterData
@export var config: BattleConfig

func execute(window: DialogueWindow, params: Dictionary) -> void:
	await window.get_tree().process_frame
	var controller: FieldMapController  = params.get("map_controller") as FieldMapController
	controller.close_command_window(false)
	controller.start_battle(encounter, config)
