extends Node2D

signal tile_selected
signal tile_placed

var current_tile: TileData = null
var current_source_id: int = -1
var current_atlas_coords: Vector2i = Vector2i(-1,-1)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _input(event):
	if not $".".is_visible():
		pass
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("Left button was clicked at ", event.position)
			print($TileMap.local_to_map(event.position))

			if event.position.x <= 1087:
				print("Placing tile")
				placeTile(event.position)
			else:
				print("Selecting tile")
				getTileData(event.position)
#		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
#			print("Wheel up")

func getTileData(screen_pos):
	var map_pos = $TileMap.local_to_map(screen_pos)
	current_tile = $TileMap.get_cell_tile_data(0, map_pos)
	current_source_id = $TileMap.get_cell_source_id(0, map_pos)
	current_atlas_coords = $TileMap.get_cell_atlas_coords(0, map_pos)

	print(current_tile)

func placeTile(screen_pos):
	if current_tile != null:
		$TileMap.set_cell(0, $TileMap.local_to_map(screen_pos), current_source_id, current_atlas_coords)
	else:
		print("No tile selected")
