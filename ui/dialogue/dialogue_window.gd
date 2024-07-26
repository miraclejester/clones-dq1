extends Control
class_name DialogueWindow

signal current_dialogue_finished()

@export var paragraph_scene: PackedScene

@export var command_event: DialogueEvent
@export var attack_wait_event: WaitSecondsDialogueEvent
@export var newline_event: NewlineDialogueEvent
@export var hero_attack_event: DialogueEvent
@export var enemy_hurt_event: DialogueEvent
@export var enemy_defeat_event: DialogueEvent
@export var exp_gain_event: DialogueEvent
@export var gold_gain_event: DialogueEvent

@onready var paragraph_container: VBoxContainer = %ParagraphContainer
@onready var scroll_container: ScrollContainer = %ScrollContainer


var num_lines: int = 0
var lines_to_transition: int = 8
var event_queue: Array[DialogueEventParams] = []
var current_paragraph: DialogueParagraph


func _ready() -> void:
	scroll_container.get_v_scroll_bar().changed.connect(scroll_to_bottom)
	
	var queue: Array[DialogueEventParams] = []
	queue.append(DialogueEventParams.fromData(command_event))
	queue.append(DialogueEventParams.fromData(attack_wait_event))
	queue.append(DialogueEventParams.fromData(hero_attack_event, {
		PlayParagraphDialogueEvent.ParagraphEventKeys.FORMAT_VARS: ["LOTO"],
		PlayParagraphDialogueEvent.ParagraphEventKeys.CONTINUING: true
	}))
	queue.append(DialogueEventParams.fromData(attack_wait_event))
	queue.append(DialogueEventParams.fromData(enemy_hurt_event, {
		PlayParagraphDialogueEvent.ParagraphEventKeys.FORMAT_VARS: ["Slime", 3],
		PlayParagraphDialogueEvent.ParagraphEventKeys.CONTINUING: true
	}))
	queue.append(DialogueEventParams.fromData(enemy_defeat_event, {
		PlayParagraphDialogueEvent.ParagraphEventKeys.FORMAT_VARS: ["Slime"]
	}))
	queue.append(DialogueEventParams.fromData(exp_gain_event, {
		PlayParagraphDialogueEvent.ParagraphEventKeys.FORMAT_VARS: [4]
	}))
	queue.append(DialogueEventParams.fromData(gold_gain_event, {
		PlayParagraphDialogueEvent.ParagraphEventKeys.FORMAT_VARS: [10],
		PlayParagraphDialogueEvent.ParagraphEventKeys.CONTINUING: true
	}))
	
	start_dialogue(queue)


func start_dialogue(initial_queue: Array[DialogueEventParams]) -> void:
	event_queue = initial_queue
	process_next_event()


func process_next_event() -> void:
	if event_queue.size() == 0:
		current_dialogue_finished.emit()
		return
	var cur_event: DialogueEventParams = event_queue.pop_front() as DialogueEventParams
	cur_event.event.event_finished.connect(process_next_event, CONNECT_ONE_SHOT)
	cur_event.event.execute(self, cur_event.params)


func create_paragraph() -> DialogueParagraph:
	var paragraph: DialogueParagraph = paragraph_scene.instantiate() as DialogueParagraph
	paragraph_container.add_child(paragraph)
	current_paragraph = paragraph
	return paragraph


func scroll_to_bottom():
	scroll_container.scroll_vertical = int(scroll_container.get_v_scroll_bar().max_value)
