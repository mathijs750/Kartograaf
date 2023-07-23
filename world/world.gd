extends Node3D

#-----------------SCENE--SCRIPT------------------#
#    Close your game faster by clicking 'Esc'    #
#   Change mouse mode by clicking 'Shift + F1'   #
#------------------------------------------------#

@export var fast_close := true

signal end_score(score)

var total_score: int = 0

var hasStarted := false
var mapActive := false
var selectedTileisLand = false
var selectedTileisSea = false
var selectedTileisForrest = false
var selectedTileisLandmark = false


# Called when the node enters the scene tree for the first time.
func startGame() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if !OS.is_debug_build():
		fast_close = false

	set_process_input(fast_close)


func _input(event: InputEvent) -> void:
#	if event.is_action_pressed(&"open_map"):
#		toggleMap()
	
	if event.is_action_pressed(&"ui_cancel"):
		get_tree().quit() # Quits the game

	if event.is_action_pressed(&"change_mouse_input"):
		toggleMouse()


# Capture mouse if clicked on the game, needed for HTML5
# Called when an InputEvent hasn't been consumed by _input() or any GUI item
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"open_map"):
		toggleMap()
	
	if event is InputEventMouseButton:
		if mapActive:
			return
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func toggleMap():
	mapActive = not mapActive
	$Map.visible = mapActive
	$WorldMap.visible = mapActive
	toggleMouse()

func toggleMouse():
	match Input.get_mouse_mode():
		Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_map_tile_selected_on_map(_tile_coords, isLand, isWater, isForrest, isLandmark):
	selectedTileisLand = isLand
	selectedTileisSea = isWater
	selectedTileisForrest = isForrest
	selectedTileisLandmark = isLandmark

func _on_world_map_tile_sampled(_tile_coords, isLand, isWater, isForrest, isLandmark):
	# Check if Land is not on Sea/Water and Water/Sea is not on Land
	if (isLand and selectedTileisSea) or (isWater and selectedTileisLand):
		return 0

	# Check if Landmarks and Forrest must be on Land
	if (isLandmark or isForrest) and !isLand:
		return 0

	# Calculate the base score
	var score = 0
	if isLand or isWater:
		score += 10

	# Add bonus if Landmark or Forrest is correct
	if (isLand and selectedTileisLand) and ((isLandmark and selectedTileisLandmark) or (isForrest and selectedTileisForrest)):
		score += 10

	total_score += score
	print("Total score: ", total_score)



func _on_map_end_game():
	print("End Game!")
	end_score.emit(total_score)

func _on_start_screen_start_game():
	$StartScreen.visible = false
	hasStarted = true
	startGame()
