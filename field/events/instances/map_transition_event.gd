extends MapEvent
class_name MapTransitionMapEvent

@export var map_key: String
@export var load_params: MapLoadParams
@export var is_stairs: bool = false

func _ready() -> void:
	var se: MapTransitionDialogueEvent = MapTransitionDialogueEvent.new()
	se.map_key = map_key
	se.load_params = load_params
	if is_stairs:
		stairs_event = se
	else:
		step_event = se
