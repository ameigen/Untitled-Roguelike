extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Game_updateDebug(worldPos, tilePos):
	$PlayerXY.text = "pworldpos: " + str(worldPos)
	$PlayerTile.text = "ptileid: " + str(tilePos)
