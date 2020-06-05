extends Node

var playerTileId = 0
var playerWorldPos = Vector2(0,0)
var generationTime = 0
signal getID
signal debugOut
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _process(delta):
	emit_signal("debugOut",str("PLAYERTILEID: " + str(playerTileId) + '\n' + "PLAYERWORLDPOS: " + str(playerWorldPos) + '\n' + "TIMETOGENERATE: " + str(generationTime)))

func _on_Player_playerMove(val,position):
	emit_signal("getID", position)
	playerWorldPos = position

func _on_TileMap_tilemapDebug(time):
	generationTime = time

func _on_TileMap_tileMapID(posID):
	playerTileId = posID
