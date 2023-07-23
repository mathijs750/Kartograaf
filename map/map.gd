extends Node2D

signal tile_selected(tile_coords, isLand, isWater, isForrest, isLandmark)
signal tile_placed(tile_coords, isLand, isWater, isForrest, isLandmark)
signal end_game

var current_tile_data: TileData = null
var current_source_id: int = -1
var current_atlas_coords: Vector2i = Vector2i(-1,-1)

var playing := true

func _input(event):
	if not is_visible() or not playing:
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
	
	if current_source_id != -1:
		$selectionMarker.position = $TileMap.map_to_local(map_pos)
		$selectionMarker.visible = true
		
		tile_selected.emit(map_pos, 
			current_tile_data.get_custom_data_by_layer_id(0),
			current_tile_data.get_custom_data_by_layer_id(1),
			current_tile_data.get_custom_data_by_layer_id(2),
			current_tile_data.get_custom_data_by_layer_id(3))
	else:
		$selectionMarker.visible = false

func placeTile(screen_pos):
	if current_tile_data != null:
		var map_pos = $TileMap.local_to_map(screen_pos)
		$TileMap.set_cell(0, map_pos, current_source_id, current_atlas_coords)
		tile_placed.emit(map_pos, 
			current_tile_data.get_custom_data_by_layer_id(0),
			current_tile_data.get_custom_data_by_layer_id(1),
			current_tile_data.get_custom_data_by_layer_id(2),
			current_tile_data.get_custom_data_by_layer_id(3))
	else:
		print("No tile selected")


func _on_submit_pressed():
	playing = false
	end_game.emit()

func _on_world_end_score(score):
	$LabelsEnd/Ending.text = "Esteemed Cartographer,

Your recently completed map of the island %s, has been reviewed with great admiration. The precision and meticulousness in your work reflect a mastery that is rare in this craft.

The clear representation of terrain, landmarks, and potential hazards are to be commended. It is with much appreciation that we give your work an accuracy score of %s, an exceptional achievement.

May this map guide our seafarers safely, reflecting the prowess of your artistry.

Yours sincerely,
Admiral Vloerbrood" % [ "Baluga", score]
	$labels.visible = false
	$EndScreen.visible = true
	$LabelsEnd.visible = true
