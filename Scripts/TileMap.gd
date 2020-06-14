extends TileMap

#sets back bounds for level *UNUSED CURRENTLY*
signal tilemapDebug
signal tileMapID
var enemyScene = preload("res://Scenes//Enemy.tscn")
var rooms = []
var roomCents = []
var enemies = []
var checkDist
var startTime
var graph = AStar2D.new()

func _ready():
	pass

#Basic call to generate a  single x*y room. Use for basis of procedural algorithm

func generateLevel(mapSize,maxRooms,rng):
	var dimensions = mapSize
	var roomItterations = 2000
	var roomCount = 20
	graph.clear()
	#rng.randi_range(maxRooms / 5, maxRooms)
	#Check OS.time to track time to generate level
	startTime = OS.get_ticks_msec()
	#Clear array of rooms on level generation
	if(enemies.size() > 0):
		for i in enemies:
			i.killFree()
	rooms.clear()
	enemies.clear()
	print("BUILDING WALLS")
	buildWalls(dimensions)
	print("FINISHED BUILDING WALLS")
	print("BUILDING ROOMS")
	while(roomCount > 0):
		var tempRoom = createRoom(dimensions,rng)
		if(intersectCheck(tempRoom)):
			rooms.push_back(tempRoom)
			drawRoom(tempRoom)
			roomCount -= 1
		else:
			roomItterations -= 1
		if(roomItterations == 0):
			print("NOSPAWN")
			roomItterations = 2000
			if(roomCount > 0):
				roomCount -= 1
	print("FINISHED BUILDING ROOMS")
	emit_signal("tilemapDebug",str(OS.get_ticks_msec() - startTime))
	print("SPAWNING ENEMIES")
	for i in rooms:
		spawnEnemies(i,rng)
	print("FINISHED SPAWNING ENEMIES")
	var test = map_to_world(rooms[rng.randi_range(0,rooms.size()-1)].center)
	set_cellv(world_to_map(test-Vector2(1,1)),0)
	makeGraph()
	return test

func makeGraph():
	for tile in get_used_cells():
		graph.add_point(graph.get_available_point_id(),tile)
	for tile in get_used_cells():	
		var id = graph.get_closest_point(tile)
		for i in range(3):
			var target
			if(i==0):
				target = tile + Vector2(-1,0)
			if(i==1):
				target = tile + Vector2(0,1)
			if(i==2):
				target = tile + Vector2(1,0)
			if(i==3):
				target = tile + Vector2(0,-1)
			var targetID = graph.get_closest_point(target)
			if tile == target or not graph.has_point(targetID):
				continue
			elif(id == targetID):
				continue
			graph.connect_points(id,targetID,true)	
	print(graph.get_point_count())
#	for i in rooms:
#		roomCents.push_back(graph.get_closest_point(i.center))
	for i in rooms:
		roomCents.push_back(graph.get_closest_point(i.center))
	print(roomCents)
	for j in range(roomCents.size()):
		if(j+2 > roomCents.size()):
			continue
		if(graph.get_id_path(roomCents[j],roomCents[j+1])):
			print("Building path")
			var setDoor = true
			var path = graph.get_id_path(roomCents[j],roomCents[j+1])
			for i in range(path.size()):
				var cur = path[i]
				var previous = path[i]
				if(i > 0):
					previous = path[i-1]
				print(previous)
				print(get_cellv(graph.get_point_position(previous)))
				if(get_cellv(graph.get_point_position(cur)) == 2):
					print("WALL")
#					if(setDoor):
#						set_cellv(graph.get_point_position(cur),0)
#						setDoor = !setDoor
#						continue
					set_cellv(graph.get_point_position(cur),1)
					continue
				if(get_cellv(graph.get_point_position(cur)) == 1):
					if(get_cellv(graph.get_point_position(previous)) == 2):
						print("FLOOR")
						break
					continue
#					if(!setDoor):
#						set_cellv(graph.get_point_position(previous),0)
#						setDoor = !setDoor
						

func buildWalls(dimensions):
	for x in dimensions.x:
		for y in dimensions.y:
			self.set_cell(x,y,2)

func createRoom(dimensions,rng):
		var spawnPoint
		var roomDims
# warning-ignore:unused_variable
		var tempX
# warning-ignore:unused_variable
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
	
	if(get_cellv(roomCenter) == -1):
		return false
		
	if(roomToCheck.type == 1 or roomToCheck.type == 2):	 #Square or Rectangle
		for x in roomDimensions.x + 4:
			for y in roomDimensions.y + 4:
				var adjustVec = Vector2(x,y)
				var checkCell = get_cellv(checkStart + adjustVec)
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

func spawnEnemies(room,rng):
	if(rng.randi_range(0,100) >= 20):	
		while(room.enemies < 5):
			var canSpawn = true
			var spawnPoint
			var spawnChance = rng.randi_range(0,100)
			var minPoint = room.getTopLeft()
			var maxPoint = room.getBottomRight()
			spawnPoint = map_to_world(Vector2(rng.randi_range(minPoint.x,maxPoint.x),rng.randi_range(minPoint.y,maxPoint.y)))
			if(spawnChance > 35):
				for i in enemies:
					if(spawnPoint == world_to_map(i.getPosition())):
						canSpawn = false
				if(canSpawn):
					var tempEnemy = enemyScene.instance()
					add_child(tempEnemy)
					#print("MAKING ENEMY" + str(tempEnemy))
					tempEnemy.createEnemy(rng,spawnPoint)
					enemies.push_back(tempEnemy)
					room.increaseEnemies()
			room.increaseEnemies()
			pass
	else:
		pass

func getEnemies():
	return enemies
	
func _on_Debug_getID(position):
	emit_signal("tileMapID",get_cellv(world_to_map(position)))
