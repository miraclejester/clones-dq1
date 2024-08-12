extends UIMenu
class_name CommandWindow

signal selected(index: int)

@export var command_label_scene: PackedScene

@onready var ui_window: NinePatchRect = $UIWindow
@onready var margin_container: MarginContainer = $MarginContainer
@onready var grid_container: GridContainer = %GridContainer

var command_callables: Array[Callable]


var selection_index: int = 0
var menu_active: bool = false

var left_margin: int
var right_margin: int
var top_margin: int
var bottom_margin: int

func _ready() -> void:
	grid_container.resized.connect(on_main_container_resized)
	left_margin = margin_container.get_theme_constant("margin_left")
	right_margin = margin_container.get_theme_constant("margin_right")
	top_margin = margin_container.get_theme_constant("margin_top")
	bottom_margin = margin_container.get_theme_constant("margin_bottom")


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


func initialize_commands(commands: Array[CommandData], columns: int) -> void:
	command_callables = []
	for child in grid_container.get_children():
		grid_container.remove_child(child)
		child.queue_free()
	grid_container.columns = columns
	var last_row_index: int = commands.size() - grid_container.columns
	var idx: int = 0
	for command in commands:
		add_command(command, idx < last_row_index, command.amount)
		idx += 1
	set_selection(0)


func add_command(command: CommandData, show_second_line: bool, amount: int = 0) -> void:
	var command_label: CommandLabel = command_label_scene.instantiate()
	grid_container.add_child(command_label)
	command_label.set_text(command.text, command.multiline, show_second_line)
	command_label.set_amount(amount)
	command_label.move_away()
	
	command_callables.append(command.callback)


func move_left() -> void:
	if selection_index % grid_container.columns == 0:
		return
	set_selection(selection_index - 1)


func move_right() -> void:
	if (selection_index + 1) % grid_container.columns == 0 or selection_index + 1 >= grid_container.get_child_count():
		return
	set_selection(selection_index + 1)


func move_down() -> void:
	if selection_index + grid_container.columns >= grid_container.get_child_count():
		return
	set_selection(selection_index + grid_container.columns)


func move_up() -> void:
	if selection_index - grid_container.columns < 0:
		return
	set_selection(selection_index - grid_container.columns)


func set_selection(idx: int) -> void:
	get_command(selection_index).move_away()
	selection_index = idx
	get_command(selection_index).highlight()


func select() -> void:
	AudioManager.play_sfx("menu_blip")
	selected.emit(selection_index)
	command_callables[selection_index].call()


func cancel() -> void:
	cancelled.emit()


func activate() -> void:
	AudioManager.play_sfx("menu_blip")
	get_command(selection_index).highlight()
	menu_active = true


func deactivate() -> void:
	get_command(selection_index).move_away()
	menu_active = false


func get_command(idx: int) -> CommandLabel:
	return grid_container.get_child(idx) as CommandLabel


func on_main_container_resized() -> void:
	var width: int = int(grid_container.size.x) + left_margin + right_margin
	var height: int = int(grid_container.size.y) + top_margin + bottom_margin
	ui_window.size = Vector2(width, height)
