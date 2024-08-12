extends Control
class_name NameEntryWindow

@onready var letter_window: CommandWindow = %LetterWindow

var letter_map: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ-`!?() abcdefghijklmnopqrstuvwxyz,."


func _ready() -> void:
	var commands: Array[CommandData] = []
	for letter in letter_map:
		commands.append(make_letter(letter))
	#commands.append(CommandData.new("BACK", func(): pass))
	#commands.append(CommandData.new("END", func(): pass))
	letter_window.initialize_commands(commands, 11)
	MenuStack.push_stack(letter_window, letter_window.activate, letter_window.deactivate)


func make_letter(letter: String) -> CommandData:
	return CommandData.new(letter, func(): pass)
