extends TileMap
class_name FieldTileMap


func request_move(target: Vector2) -> bool:
	var tile: TileData = get_cell_tile_data(0, local_to_map(target))
	return not (tile.get_custom_data("Blocking") as bool)
