extends Node

var message_speeds: Array[float] = [0.015, 0.035, 0.06]
var message_speed_index: int = 0

func set_message_speed(idx: int) -> void:
	message_speed_index = idx


func get_message_speed() -> float:
	return message_speeds[message_speed_index]


func generate_save_data() -> Dictionary:
	return {
		"message_speed": message_speed_index
	}


func load_from_data(data: Dictionary) -> void:
	set_message_speed(data.get("message_speed", 0))
