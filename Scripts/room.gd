extends Node

class_name Room

var dimensions = Vector2(0,0)
var roomCent = Vector2(0,0)
var doors = 0

func _init(x,y,center):
	dimensions.x = x
	dimensions.y = y
	roomCent = center
	
	

func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
