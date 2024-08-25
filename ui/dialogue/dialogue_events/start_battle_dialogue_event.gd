extends DialogueEvent
class_name StartBattleDialogueEvent

@export var encounter: EncounterData
@export var config: BattleConfig

func execute(window: DialogueWindow, params: Dictionary) -> void:
	await window.get_tree().process_frame
	(params.get("map_controller") as FieldMapController).start_battle(encounter, config)
