extends Control
class_name DialogueWindow

signal current_dialogue_finished()

@export var paragraph_scene: PackedScene

@onready var paragraph_container: VBoxContainer = %ParagraphContainer

var num_lines: int = 0
var lines_to_transition: int = 7
var paragraph_queue: Array[DialogueParagraphOptions] = []

func _ready() -> void:
	var t1: DialogueParagraphOptions = DialogueParagraphOptions.fromString("A Red Slime draws near!")
	var t2: DialogueParagraphOptions = DialogueParagraphOptions.fromString("Command?")
	start_dialogue([t1, t2])


func start_dialogue(initial_queue: Array[DialogueParagraphOptions]) -> void:
	paragraph_queue = initial_queue
	play_next_paragraph()


func play_next_paragraph() -> void:
	if paragraph_queue.size() == 0:
		current_dialogue_finished.emit()
		return
	var cur_paragraph: DialogueParagraphOptions = paragraph_queue.pop_front()
	play_paragraph(cur_paragraph)


func play_paragraph(options: DialogueParagraphOptions) -> void:
	var paragraph: DialogueParagraph = paragraph_scene.instantiate() as DialogueParagraph
	paragraph_container.add_child(paragraph)
	paragraph.paragraph_finished.connect(play_next_paragraph, CONNECT_ONE_SHOT)
	paragraph.play_paragraph(options)
