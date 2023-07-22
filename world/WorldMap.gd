extends TileMap

signal tile_sampled(tile_coords, isLand, isWater, isForrest, isLandmark)

var current_tile_data: TileData = null

func _input(event):
	if not is_visible():
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			sampleTile(event.position)

func sampleTile(screen_pos):
	var map_pos = $TileMap.local_to_map(screen_pos)
	current_tile_data = $TileMap.get_cell_tile_data(0, map_pos)
	tile_sampled.emit(map_pos, 
			current_tile_data.get_custom_data_by_layer_id(0),
			current_tile_data.get_custom_data_by_layer_id(1),
			current_tile_data.get_custom_data_by_layer_id(2),
			current_tile_data.get_custom_data_by_layer_id(3) )


