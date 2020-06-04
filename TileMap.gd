extends TileMap

var levelWidth = 100
var levelHeight = 100
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#Basic call to generate a room. Use for basis of procedural algorithm
func _level_generation(width, height):
	for x in range(width+1):
		for y in range(height+1):
			print(str(x) + ',' + str(y))
			if(x == 0 or y == 0 or x == width or y== height):
				self.set_cell(x,y,2)
			else:
				self.set_cell(x,y,1)
				
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

