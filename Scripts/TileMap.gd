extends TileMap

#sets back bounds for level *UNUSED CURRENTLY*
signal tilemapDebug
signal tileMapID
var rng = RandomNumberGenerator.new()
var rooms = []
var checkDist
var startTime

func _ready():
	rng.randomize()

#Basic call to generate a  single x*y room. Use for basis of procedural algorithm

func generateLevel(mapSize,maxRooms):
	var dimensions = mapSize
	var roomItterations = 10000
	var roomCount = rng.randi_range(maxRooms / 5, maxRooms)
	#Check OS.time to track time to generate level
	startTime = OS.get_ticks_msec()
	#Clear array of rooms on level generation
	rooms.clear()
	buildWalls(dimensions)
	while(roomCount > 0):
		var tempRoom = createRoom(dimensions)
		if(intersectCheck(tempRoom)):
			rooms.push_back(tempRoom)
			drawRoom(tempRoom)
			roomCount -= 1
		else:
			roomItterations -= 1
		if(roomItterations == 0):
			roomCount -= 1
	emit_signal("tilemapDebug",str(OS.get_ticks_msec() - startTime))
	return rooms[rng.randi_range(0,rooms.size()-1)].center

func buildWalls(dimensions):
	for x in dimensions.x:
		for y in dimensions.y:
			self.set_cell(x,y,2)

func createRoom(dimensions):
		var spawnPoint
		var roomDims
		var roomSize
		var tempX
		var tempY
		var center
		var type = rng.randi_range(1,2) #Temporary until we add other room types
		
		if(type == 1): #Square
			#print("Square")
			spawnPoint = Vector2(rng.randi_range(5,dimensions.x-5),rng.randi_range(5,dimensions.y-5))
			#print("Spawning at: " + str(spawnPoint))
			var size = rng.randi_range(5,rng.randi_range(5,30))
			if(size % 2 == 0):
				size += 1
			roomDims = Vector2(size,size)
			center = spawnPoint
			return Room.new(1,roomDims,center)
			
		if(type == 2): #Rectangle
			#print("Rectangle")
			spawnPoint = Vector2(rng.randi_range(3,dimensions.x-3),rng.randi_range(3,dimensions.y-3))
			roomDims = randomVector2(rng,5,30)
			if(int(roomDims.x) % 2 == 0):
				roomDims.x += 1
			if(int(roomDims.y) % 2 == 0):
				roomDims.y += 1
			center = spawnPoint
			return Room.new(2,roomDims,center)
			
func intersectCheck(roomToCheck):
	var roomCenter = roomToCheck.center
	var roomDimensions = roomToCheck.dimensions
	#print(str(floor(roomDimensions.x/2) + floor(roomDimensions.y/2))) 
	var checkStart = Vector2(roomCenter.x-floor(roomDimensions.x/2),roomCenter.y-floor(roomDimensions.y/2))-Vector2(3,3)
	#print ("CheckStart: ", str(checkStart))
	
	if(self.get_cellv(roomCenter) == -1):
		return false
		
	if(roomToCheck.type == 1 or roomToCheck.type == 2):	 #Square or Rectangle
		for x in roomDimensions.x + 4:
			for y in roomDimensions.y + 4:
				var adjustVec = Vector2(x,y)
				var checkCell = self.get_cellv(checkStart + adjustVec)
				if(checkCell == -1 or checkCell == 1):
					#print("INTERSECTION")
					return false
		return true		
	
func drawRoom(room):
	var type = room.type
	var center = room.center
	var dimensions = Vector2(floor(int(room.dimensions.x/2)),floor(int(room.dimensions.y/2)))
	var start = center - dimensions
	#print("Type of Room: " + str(type))
	#print("Room Center: " + str(center))
	#print("Room Dimensions : " + str(room.dimensions))
	#print("Room Dimensions Float: " + str(dimensions))
	#print("Room Draw Start: " + str(start))
	if(type == 1 or type == 2):
		for x in room.dimensions.x:
			for y in room.dimensions.y:
				var adjustVec = Vector2(x,y)
				self.set_cellv(start+adjustVec,1)
				
func randomVector2(randomGen,minRange,maxRange):
	var val1
	var val2
	var randVecOut
	val1 = randomGen.randi_range(minRange,randomGen.randi_range(minRange,maxRange))
	val2 = randomGen.randi_range(minRange,randomGen.randi_range(minRange,maxRange))
	randVecOut = Vector2(val1,val2)
	return randVecOut
	
func _on_Debug_getID(position):
	emit_signal("tileMapID",self.get_cellv(self.world_to_map(position)))
