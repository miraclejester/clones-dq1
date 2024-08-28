extends DialogueEvent
class_name StartTrueDragonlordBattleDialogueEvent

@export var final_boss_encounter: EncounterData
@export var final_boss_config: BattleConfig

func execute(window: DialogueWindow, params: Dictionary) -> void:
	await window.get_tree().process_frame
	window.auto_continue = true
	var controller: FieldMapController = params.get("map_controller") as FieldMapController
	await GlobalVisuals.fade_out()
	controller.hero_character.visible = false
	controller.field_map.show_darkness()
	controller.battle_controller.set_visibility(false)
	GlobalVisuals.lighten_up()
	
	controller.close_command_window(false)
	controller.start_battle(final_boss_encounter, final_boss_config)
