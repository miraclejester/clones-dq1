extends UIMenu
class_name NameEntryWindow

signal name_filled(name: String)

@onready var letter_window: CommandWindow = %LetterWindow
@onready var name_display_window: NameDisplayWindow = %NameDisplayWindow
@onready var back_command: CommandLabel = %BackCommand
@onready var end_command: CommandLabel = %EndCommand

var letter_map: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ-`!?() abcdefghijklmnopqrstuvwxyz,."


func _ready() -> void:
	var commands: Array[CommandData] = []
	letter_window.cancelled.connect(func(): cancelled.emit())
	name_display_window.name_filled.connect(on_name_filled)
	
	for letter in letter_map:
		commands.append(make_letter(letter))
	letter_window.initialize_commands(commands, 11)
	letter_window.add_floating_command(CommandData.new(
		"BACK",
		back,
		0,
		false,
		{
			"right": 62 
		}
	), back_command)
	letter_window.add_floating_command(CommandData.new(
		"END",
		func(): on_name_filled(name_display_window.get_final_name()),
		0,
		false,
		{
			"left": 61,
			"up": 53 
		}
	), end_command)


func make_letter(letter: String) -> CommandData:
	var c: Callable = set_letter.bind(letter)
	if letter in "rs":
		return CommandData.new(letter, c, 0, false, {
			"down" : 61
		})
	elif letter in "tuv":
		return CommandData.new(letter, c, 0, false, {
			"down" : 62
		})
	elif letter == ".":
		return CommandData.new(letter, c, 0, false, {
			"right" : 61
		})
	return CommandData.new(letter, c, 0, false, {})


func set_letter(letter: String) -> void:
	name_display_window.set_letter(letter)


func back() -> void:
	name_display_window.go_back()


func activate() -> void:
	name_display_window.reset()
	letter_window.activate()


func deactivate() -> void:
	letter_window.deactivate()


func on_name_filled(n: String) -> void:
	name_filled.emit(n)
