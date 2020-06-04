extends Node2D
signal processTurn
signal updateDebug
var playerTurn = true;
onready var Lerp = $Lerp

#temp for random room size

func _ready():
	$TileMap._level_generation(7,7)

#Takes in a position(Vec2) and checks if it is a valid tile to move to
func _tile_Check(position):
	var check = ($TileMap.get_cellv($TileMap.world_to_map(position)) == 0 or $TileMap.get_cellv($TileMap.world_to_map(position)) == 1)
	emit_signal("updateDebug",position,$TileMap.get_cellv($TileMap.world_to_map(position)))
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

#Calculates tile in direction passed, 32units from player
func _on_Player_playerMove(direction,position):
	playerMovementHandler(direction, position)

#Itterate through enemies in tree. Once reaching end set playerTurn true
#	Check enemy 'seen' value. If visible lerp animation. Otherwise move 
#   directly to target location if valid movement.
func _on_Lerp_lerpFinished():
	playerTurn = true
	print("MY TURN")
