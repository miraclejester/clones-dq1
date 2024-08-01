extends Control
class_name DialogueWindow

signal current_dialogue_finished()

@export var paragraph_scene: PackedScene
@export var newline_settings: LabelSettings
@export var standard_settings: LabelSettings

@onready var paragraph_container: VBoxContainer = %ParagraphContainer
@onready var scroll_container: ScrollContainer = %ScrollContainer


var num_lines: int = 0
var lines_to_transition: int = 8
var event_queue: Array[DialogueEventParams] = []
var current_paragraph: DialogueParagraph


func _ready() -> void:
	scroll_container.get_v_scroll_bar().changed.connect(scroll_to_bottom)
	create_paragraph()


func show_paragraph(id: GeneralDialogueProvider.DialogueID, format_vars: Array = []) -> DialogueWindow:
	return await show_paragraph_from_data(GeneralDialogueProvider.get_dialogue(id), format_vars).current_dialogue_finished


func show_paragraph_from_data(data: DialogueEvent, format_vars: Array = []) -> DialogueWindow:
	var queue: Array[DialogueEventParams] = []
	queue.append(DialogueEventParams.fromData(data, {
		PlayParagraphDialogueEvent.ParagraphEventKeys.FORMAT_VARS : format_vars
	}))
	start_dialogue(queue)
	return self


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
	paragraph.custom_label_settings = standard_settings
	return paragraph


func create_newline() -> DialogueParagraph:
	var p: DialogueParagraph = create_paragraph()
	p.custom_label_settings = newline_settings
	return p


func scroll_to_bottom():
	scroll_container.scroll_vertical = int(scroll_container.get_v_scroll_bar().max_value)
