extends RefCounted
class_name DialogueParagraphOptions

var text: String
var in_quotes: bool = false
var word_wrap_length: int = 177

static func fromString(t: String) -> DialogueParagraphOptions:
	var res: DialogueParagraphOptions = DialogueParagraphOptions.new()
	res.text = t
	return res
