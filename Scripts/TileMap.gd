extends TileMap

#sets back bounds for level *UNUSED CURRENTLY*
signal tilemapDebug
signal tileMapID
var levelWidth = 10
var levelHeight = 10
var rng = RandomNumberGenerator.new()
export var maxRooms = 100;
var rooms = []
var spawnPoint
var dims
var size
var checkDist
var tempX
var tempY
var startTime

func _ready():
	rng.randomize()

#Basic call to generate a  single x*y room. Use for basis of procedural algorithm
func level_generation(width, height):
	rooms.clear()
	startTime = OS.get_ticks_msec()
	var roomCount = maxRooms
	for x in width:
		for y in height:
			self.set_cell(x,y,2)
	while(roomCount > 0):
		spawnPoint = Vector2(rng.randi_range(3,width-3),rng.randi_range(3,height-3))
		dims = rng.randi_range(5,20)
		size = Vector2(dims,dims)
		tempX = spawnPoint-size
		tempY = spawnPoint+size
		var center = Vector2(tempX.x+dims/2,tempY.y+dims/2)
		if(intersectCheck(tempX,tempY)):
			for x in dims+1:
				for y in dims+1:
					self.set_cellv(Vector2(x+tempX.x,y+tempY.y),1)
			var tempRoom = Room.new(tempX.x,tempY.y,center)
			rooms.push_back(tempRoom)
			roomCount -= 1
	emit_signal("tilemapDebug",str(OS.get_ticks_msec() - startTime))
	for i in rooms:
		self.set_cellv(i.roomCent,-1)
	return rooms[rng.randi_range(0,maxRooms - 1)].roomCent
	
func intersectCheck(startPoint,endPoint):
	if(self.get_cell(startPoint.x,endPoint.y) == -1):
		return false
	for x in dims+7:
		for y in dims+7:
			var checkCell = self.get_cellv(Vector2(x-3+startPoint.x,y-3+endPoint.y))
			if(checkCell == -1 or checkCell == 1):
				return false
	return true
#Room Building Function
	#	Check if Floor Tile Exists Within Boundaries
		#	If not create new object of class room
			#	Class room contains Vec2(dimensions)
			#	Number of entrances
			# 	Store room on array of rooms
			#	When creating entrances parse number of entrances
			#	in room (check if point exists in room, return entrace number)
			#	extern var for max number of entrances
		#	Else pick new spot
	
func _on_Debug_getID(position):
	emit_signal("tileMapID",self.get_cellv(self.world_to_map(position)))
