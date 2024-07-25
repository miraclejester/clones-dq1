extends Node

func load_json_dict(path: String) -> Dictionary:
	var json: JSON = JSON.new()
	var file = FileAccess.open(path, FileAccess.READ)
	var json_text: String = file.get_as_text()
	file.close()
	
	var error: Error = json.parse(json_text)
	if error == OK:
		if typeof(json.data) == TYPE_DICTIONARY:
			return json.data
		else:
			print("Json Data in wrong type")
			return {}
	else:
		print("Error reading json")
		return {}
