extends Node2D
class_name MapEvent

@export var take_event: DialogueEvent
@export var search_event: DialogueEvent
@export var door_event: DialogueEvent
@export var stairs_event: DialogueEvent

@onready var take_params: Node = %TakeParams
@onready var door_params: Node = %DoorParams


func get_take_params() -> Dictionary:
	return get_params(take_params)


func get_door_params() -> Dictionary:
	return get_params(door_params)


func get_params(container: Node) -> Dictionary:
	var res: Dictionary = {}
	for param in container.get_children():
		var p: EventParamProvider = param as EventParamProvider
		p.target_event = self
		for key in p.keys:
			res[key] = p.get_param()
	return res
