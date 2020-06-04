extends TileMap

#sets back bounds for level *UNUSED CURRENTLY*
var levelWidth = 100
var levelHeight = 100

func _ready():
	pass

#Basic call to generate a  single x*y room. Use for basis of procedural algorithm
func _level_generation(width, height):
	for x in range(width+1):
		for y in range(height+1):
			if(x == 0 or y == 0 or x == width or y== height):
				self.set_cell(x,y,2)
			else:
				self.set_cell(x,y,1)


