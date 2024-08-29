extends DialogueEvent
class_name LorikEndgameDialogueEvent

@export_group("Dialogues")
@export var initial_dialogue: DialogueEvent
@export var gwaelin_initial_dialogue: DialogueEvent
@export var gwaelin_go_wish: DialogueEvent
@export var gwaelin_go_question: DialogueEvent
@export var gwaelin_insistence: DialogueEvent
@export var gwaelin_so_happy: DialogueEvent
@export var tale_end_dialogue: DialogueEvent

@export_group("Characters")
@export var princess_spawn_pos: Vector2
@export var princess_move_target: Vector2
@export var princess_scene: PackedScene
@export var hero_initial_pos: Vector2
@export var guard_positions: Array[Vector2]

@export_group("Leaving")
@export var target_scene: PackedScene

var accepted: bool = false

func execute(window: DialogueWindow, params: Dictionary) -> void:
	var controller: FieldMapController = params.get("map_controller") as FieldMapController
	
	var old_pos: Vector2 = controller.hero_character.position
	controller.hero_character.position = hero_initial_pos
	controller.field_map.move_character_register(old_pos, controller.hero_character)
	controller.hero_character.set_face_dir(Vector2.UP)
	
	controller.field_ui.hide_command_window()
	controller.field_ui.hide_hud()
	
	AudioManager.play_bgm("")
	await window.start_dialogue([
		DialogueEventParams.fromData(initial_dialogue)
	])
	if GameDataManager.get_map_bool("tantegel_throne", "princess_returned"):
		controller.field_map.spawn_character(princess_scene, princess_spawn_pos)
		var princess_npc: NPCCharacter = controller.field_map.find_npc(princess_spawn_pos)
		princess_npc.set_face_dir(Vector2.RIGHT)
		await window.wait_for_continuation(true)
		await window.start_dialogue([
			DialogueEventParams.fromData(gwaelin_initial_dialogue)
		])
		princess_npc.process_mode = Node.PROCESS_MODE_ALWAYS
		princess_npc.field_move_component.request_move(princess_move_target)
		await princess_npc.field_move_component.move_finished
		princess_npc.set_face_dir(Vector2.DOWN)
		princess_npc.process_mode = Node.PROCESS_MODE_INHERIT
		await window.show_newline()
		await window.start_dialogue([
			DialogueEventParams.fromData(gwaelin_go_wish)
		])
		await window.wait_for_continuation(true)
		while not accepted:
			await window.start_dialogue([
				DialogueEventParams.fromData(gwaelin_go_question)
			])
			window.prompt_yes_no(accepted_princess, func (): pass)
			await window.yes_no_responded
			if not accepted:
				await window.show_newline()
				await window.start_dialogue([
					DialogueEventParams.fromData(gwaelin_insistence)
				])
				await window.wait_for_continuation(true)
		await window.show_newline()
		await window.start_dialogue([
			DialogueEventParams.fromData(gwaelin_so_happy)
		])
		princess_npc.visible = false
		PlayerManager.hero.change_princess_status(true)
	
	await window.wait_for_continuation(true)
	for i in range(5):
		await window.show_newline()
	await window.start_dialogue([
		DialogueEventParams.fromData(tale_end_dialogue)
	])
	for i in range(3):
		await window.show_newline()
	await window.wait_for_continuation(true)
	window.visible = false
	
	controller.hero_character.set_face_dir(Vector2.RIGHT)
	await window.get_tree().create_timer(0.4).timeout
	controller.hero_character.set_face_dir(Vector2.DOWN)
	await window.get_tree().create_timer(0.4).timeout
	for pos in guard_positions:
		var guard: NPCCharacter = controller.field_map.find_npc(pos)
		guard.set_frame(8)
	await window.get_tree().create_timer(1).timeout
	
	AudioManager.play_bgm("ending")
	await window.get_tree().create_timer(10.75).timeout
	await GlobalVisuals.fade_out()
	
	window.get_tree().change_scene_to_packed(target_scene)


func accepted_princess() -> void:
	accepted = true
