extends Control
class_name CommandWindow

signal selected(index: int)
signal cancelled()

@export var commands: Array[CommandLabel]
@export var rows: int = 2
@export var columns: int = 2

@onready var ui_window: NinePatchRect = $UIWindow
@onready var margin_container: MarginContainer = $MarginContainer


var selection_index: int = 0
var menu_active: bool = false

func _ready() -> void:
	margin_container.resized.connect(on_main_container_resized)

func _process(_delta: float) -> void:
	if not menu_active:
		return
	
	if Input.is_action_just_pressed("left"):
		move_left()
	elif Input.is_action_just_pressed("right"):
		move_right()
	elif Input.is_action_just_pressed("down"):
		move_down()
	elif Input.is_action_just_pressed("up"):
		move_up()
	
	if Input.is_action_just_pressed("A"):
		select()
	elif Input.is_action_just_pressed("B"):
		cancel()


func move_left() -> void:
	if selection_index % columns == 0:
		return
	set_selection(selection_index - 1)


func move_right() -> void:
	if (selection_index + 1) % columns == 0:
		return
	set_selection(selection_index + 1)


func move_down() -> void:
	if selection_index + columns >= commands.size():
		return
	set_selection(selection_index + columns)


func move_up() -> void:
	if selection_index - columns < 0:
		return
	set_selection(selection_index - columns)


func set_selection(idx: int) -> void:
	commands[selection_index].move_away()
	selection_index = idx
	commands[selection_index].highlight()


func select() -> void:
	selected.emit(selection_index)


func cancel() -> void:
	cancelled.emit()


func activate() -> void:
	commands[selection_index].highlight()
	menu_active = true


func deactivate() -> void:
	commands[selection_index].move_away()
	menu_active = false


func on_main_container_resized() -> void:
	ui_window.size = margin_container.size
