extends Node2D
signal processTurn
signal updateDebug

func _ready():
	pass # Replace with function body.

#Takes in a position(Vec2) and checks if it is a valid tile to move to
func _tile_Check(position):
	var check = ($TileMap.get_cellv($TileMap.world_to_map(position)) == 0 or $TileMap.get_cellv($TileMap.world_to_map(position)) == 1)
	emit_signal("updateDebug",position,$TileMap.get_cellv($TileMap.world_to_map(position)))
	return check

#Calculates tile in direction passed, 32units from player
func _on_Player_playerMove(direction,position):
	#Basic Movement Handling
	var tempPos = position
	if(direction == 0):
		tempPos.x -= 32
		if(_tile_Check(tempPos)):
			print("MOVING")
			$Player.position.x -= 32
	if(direction == 1):
		tempPos.x += 32
		if(_tile_Check(tempPos)):
			$Player.position.x += 32
	if(direction == 2):
		tempPos.y -= 32
		if(_tile_Check(tempPos)):
			$Player.position.y -= 32
	if(direction == 3):
		tempPos.y += 32
		if(_tile_Check(tempPos)):
			$Player.position.y += 32
