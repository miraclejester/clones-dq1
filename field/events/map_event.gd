extends Node2D
class_name MapEvent

@export var take_event: DialogueEvent
@export var search_event: DialogueEvent

@onready var take_params: Node = %TakeParams


func get_take_params() -> Dictionary:
	var res: Dictionary = {}
	for param in take_params.get_children():
		var p: EventParamProvider = param as EventParamProvider
		p.target_event = self
		for key in p.keys:
			res[key] = p.get_param()
	return res
