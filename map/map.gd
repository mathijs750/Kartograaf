extends Node2D

signal tile_selected(tile_coords, isLand, isWater, isForrest, isLandmark)
signal tile_placed(tile_coords, isLand, isWater, isForrest, isLandmark)

var current_tile_data: TileData = null
var current_source_id: int = -1
var current_atlas_coords: Vector2i = Vector2i(-1,-1)

func _input(event):
	if not is_visible():
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if event.position.x <= 1087:
				placeTile(event.position)
			else:
				getTileData(event.position)
#		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
#			print("Wheel up")

func getTileData(screen_pos):
	var map_pos = $TileMap.local_to_map(screen_pos)
	current_tile_data = $TileMap.get_cell_tile_data(0, map_pos)
	current_source_id = $TileMap.get_cell_source_id(0, map_pos)
	current_atlas_coords = $TileMap.get_cell_atlas_coords(0, map_pos)
	tile_selected.emit(map_pos, 
			current_tile_data.get_custom_data_by_layer_id(0),
			current_tile_data.get_custom_data_by_layer_id(1),
			current_tile_data.get_custom_data_by_layer_id(2),
			current_tile_data.get_custom_data_by_layer_id(3) )

func placeTile(screen_pos):
	if current_tile_data != null:
		var map_pos = $TileMap.local_to_map(screen_pos)
		$TileMap.set_cell(0, map_pos, current_source_id, current_atlas_coords)
		tile_placed.emit(map_pos, 
			current_tile_data.get_custom_data_by_layer_id(0),
			current_tile_data.get_custom_data_by_layer_id(1),
			current_tile_data.get_custom_data_by_layer_id(2),
			current_tile_data.get_custom_data_by_layer_id(3) )
	else:
		print("No tile selected")
