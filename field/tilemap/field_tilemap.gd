extends TileMap
class_name FieldTileMap

var known_tiles: Dictionary = {
	"brick" : Vector2i(3, 0)
}

var layer_id_dict: Dictionary = {
	"Map" : 0,
	"BuildingInterior" : 1,
	"BuildingRooftop" : 2
}


func request_move(target: Vector2) -> bool:
	var tile: TileData = get_cell_tile_data(0, local_to_map(target))
	if tile != null:
		return not (tile.get_custom_data("Blocking") as bool)
	var interior_tile: TileData = get_cell_tile_data(1, local_to_map(target))
	return not (interior_tile.get_custom_data("Blocking") as bool)


func set_tile(pos: Vector2, coords: Vector2i) -> void:
	set_cell(0, local_to_map(pos), 0, coords)


func set_tile_key(pos: Vector2, key: String) -> void:
	set_tile(pos, known_tiles.get(key, Vector2i.ZERO))


func get_layer_id(key: String) -> int:
	return layer_id_dict.get(key, 0)


func get_tile_battle_id(pos: Vector2) -> EncounterChanceEntry.TileBattleID:
	var tile: TileData = get_cell_tile_data(0, local_to_map(pos))
	return tile.get_custom_data("BattleKey") as EncounterChanceEntry.TileBattleID


func get_tile_damage(pos: Vector2) -> int:
	var tile: TileData = get_cell_tile_data(0, local_to_map(pos))
	return tile.get_custom_data("Damage") as int


func building_entered() -> void:
	set_layer_enabled(get_layer_id("Map"), false)
	set_layer_enabled(get_layer_id("BuildingRooftop"), false)


func building_exited() -> void:
	set_layer_enabled(get_layer_id("Map"), true)
	set_layer_enabled(get_layer_id("BuildingRooftop"), true)
