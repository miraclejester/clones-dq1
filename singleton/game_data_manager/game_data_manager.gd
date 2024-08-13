extends Node

@export_dir var items_dir: String
@export_dir var equipment_dir: String

var save_dict: Dictionary = {} #Json
var item_dict: Dictionary = {} #int to ItemData

var save_path: String = "user://"
var current_file_index: int = 1

func _ready() -> void:
	generate_item_database()


func generate_item_database() -> void:
	load_items_from_dir(items_dir)
	load_items_from_dir(equipment_dir + "/weapons")
	load_items_from_dir(equipment_dir + "/shields")
	load_items_from_dir(equipment_dir + "/armor")


func get_item(id: int) -> ItemData:
	return item_dict.get(id) as ItemData


func get_starting_map_key() -> String:
	return (save_dict.get("map") as Dictionary).get("map_key", "")


func load_items_from_dir(dir: String) -> void:
	for file_name in DirAccess.get_files_at(dir):
		var item: ItemData = load("%s/%s" % [dir, file_name]) as ItemData
		item_dict[item.item_id] = item


func save_game() -> void:
	generate_save_data()
	save_to_file(current_file_index)


func create_new_game(hero_name: String) -> void:
	generate_new_save_data(hero_name)
	save_to_file(current_file_index)


func save_to_file(file_index: int) -> void:
	var save_file: FileAccess = FileAccess.open("%sfile%d.save" % [save_path, file_index], FileAccess.WRITE)
	save_file.store_var(save_dict)


func generate_save_data() -> void:
	save_dict = {}
	
	save_dict["player"] = PlayerManager.generate_save_data()
	save_dict["settings"] = GameSettings.generate_save_data()
	save_dict["map"] = {
		"map_key": "brecconary/tantegel_throne"
	}
	
	var save_handlers: Array[SaveDataHandler] = []
	save_handlers.assign(get_tree().get_nodes_in_group("save_handler"))
	for handler in save_handlers:
		var entry: SaveDataEntry = handler.get_save_data()
		save_dict[entry.key] = entry.data


func generate_new_save_data(hero_name: String) -> void:
	save_dict = {
		"player": {
			"level": 1,
			"gold": 0,
			"experience": 0,
			"hero_name": hero_name,
			"hp": 15,
			"mp": 0,
			"items": [],
			"equipment": []
		},
		"map": {
			"map_key": "brecconary/new_game_tantegel_throne"
		},
		"settings": {
			"message_speed": 0
		}
	}


func load_from_local_data() -> void:
	PlayerManager.load_from_data(save_dict.get("player", {}))
	GameSettings.load_from_data(save_dict.get("settings", {}))


func get_filled_slots() -> Array[int]:
	var res: Array[int] = []
	for i in range(1, 4):
		if FileAccess.file_exists("%sfile%d.save" % [save_path, i]):
			res.append(i)
	return res
