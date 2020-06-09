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


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
