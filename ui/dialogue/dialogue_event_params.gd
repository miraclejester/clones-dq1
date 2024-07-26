extends RefCounted
class_name DialogueEventParams

var event: DialogueEvent
var params: Dictionary

static func fromData(e: DialogueEvent, p: Dictionary = {}) -> DialogueEventParams:
	var res: DialogueEventParams = DialogueEventParams.new()
	res.event = e
	res.params = p
	return res
