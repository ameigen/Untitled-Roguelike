extends Node2D

signal processTurn
signal takeDamage

var playerTurn = true;
var mainMenu = preload("res://Scenes//MainMenu.tscn")
onready var Lerp = $Lerp
#temp vals for map gen
export var mapSize = Vector2(100,100)
var maxRooms = (mapSize.x+mapSize.y)/2

func _ready():
	var main = mainMenu.instance()
	add_child(main)
#Debug Stuff
func _input(event):
	if Input.is_action_pressed("ui_accept"):
		$Player.position = ($TileMap.map_to_world($TileMap.generateLevel(mapSize,maxRooms)))
	if Input.is_action_pressed("debug_camera_left"):
		$debugCam.position.x -= 50
	if Input.is_action_pressed("debug_camera_right"):
		$debugCam.position.x += 50
	if Input.is_action_pressed("debug_camera_up"):
		$debugCam.position.y -= 50
	if Input.is_action_pressed("debug_camera_down"):
		$debugCam.position.y += 50
	if Input.is_action_pressed("debug_camera_zoom_in"):
		$debugCam.zoom -= Vector2(1,1)
	if Input.is_action_pressed("debug_camera_zoom_out"):
		$debugCam.zoom += Vector2(1,1)
	if Input.is_action_pressed("debug_camera_activate"):
		if($debugCam.current):
			$debugCam.current = false
			$Player/PlayerCamera.current = true
		else:
			$Player/PlayerCamera.current = false
			$debugCam.current = true
#	Takes in a position(Vec2) and checks if it is a valid tile to move to
func _tile_Check(position):
	var check = ($TileMap.get_cellv($TileMap.world_to_map(position)) == 0 or $TileMap.get_cellv($TileMap.world_to_map(position)) == 1)
	return check

	#Basic Movement Handling
func playerMovementHandler(direction, position):
	if(playerTurn):
		var tempPos = position
		if(direction == 0):
			tempPos.x -= 32
			if(_tile_Check(tempPos)):
				playerTurn = false
				Lerp.lerpToSpot(tempPos, $Player)
		if(direction == 1):
			tempPos.x += 32
			if(_tile_Check(tempPos)):
				playerTurn = false
				Lerp.lerpToSpot(tempPos, $Player)
		if(direction == 2):
			tempPos.y -= 32
			if(_tile_Check(tempPos)):
				playerTurn = false
				Lerp.lerpToSpot(tempPos, $Player)
		if(direction == 3):
			tempPos.y += 32
			if(_tile_Check(tempPos)):
				playerTurn = false
				Lerp.lerpToSpot(tempPos, $Player)
		print($TileMap.world_to_map(tempPos))

#	Calculates tile in direction passed, 32units from player
func _on_Player_playerMove(direction,position):
	playerMovementHandler(direction, position)

#	Itterate through enemies in tree. Once reaching end set playerTurn true
#	Check enemy 'seen' value. If visible lerp animation. Otherwise move 
#   directly to target location if valid movement.
func _on_Lerp_lerpFinished():
	playerTurn = true

