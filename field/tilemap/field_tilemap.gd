extends TileMap
class_name FieldTileMap

var known_tiles: Dictionary = {
	"brick" : Vector2i(3, 0)
}


func request_move(target: Vector2) -> bool:
	var tile: TileData = get_cell_tile_data(0, local_to_map(target))
	return not (tile.get_custom_data("Blocking") as bool)


func set_tile(pos: Vector2, coords: Vector2i) -> void:
	set_cell(0, local_to_map(pos), 0, coords)


func set_tile_key(pos: Vector2, key: String) -> void:
	set_tile(pos, known_tiles.get(key, Vector2i.ZERO))
