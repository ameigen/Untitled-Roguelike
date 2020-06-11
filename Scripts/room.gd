extends Node

class_name Room

var dimensions = Vector2(0,0)
var center = Vector2(0,0)
var doors = 0
var enemies = 0
var type

func _init(typ,size,cent):
	type = typ
	dimensions = size
	center = cent
	
func _ready():
	pass

func getTopLeft():
	return (center - Vector2(floor(int(dimensions.x/2)),floor(int(dimensions.y/2))))
	
func getBottomRight():
	return (center + Vector2(floor(int(dimensions.x/2)),floor(int(dimensions.y/2))))

func increaseEnemies():
	enemies += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
