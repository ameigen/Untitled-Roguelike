extends Node2D

signal processTurn
signal takeDamage

var debug = true
var preGame = true
var playerTurn = true
var enemyTurn = false
var mainMenuPre = preload("res://Scenes//MainMenu.tscn")
var mainMenu
var rng = RandomNumberGenerator.new()
onready var Player = $Player
onready var PlayerSprite = $Player/PlayerSprite
onready var PlayerCamera = $Player/PlayerCamera
onready var Dungeon = $Dungeon
onready var UI = $UI/HUD
onready var Log = $UI/HUD/SubHUD/CombatLog
var mapSize = Vector2()
var maxRooms

func _ready():
	mainMenu = createMainMenu()
	
#Debug Stuff
func _input(event):
	if(debug):
		if Input.is_action_pressed("ui_accept"):
			Player.position = Dungeon.generateLevel(mapSize,maxRooms,rng)
		if Input.is_action_pressed("debug_camera_left"):
			$debugCam.position.x -= 50
		if Input.is_action_pressed("debug_camera_right"):
			$debugCam.position.x += 50
		if Input.is_action_pressed("debug_camera_up"):
			$debugCam.position.y -= 50
		if Input.is_action_pressed("debug_camera_down"):
			$debugCam.position.y += 50
		if Input.is_action_pressed("debug_camera_zoom_in"):
			$debugCam.zoom -= Vector2(1,1)
		if Input.is_action_pressed("debug_camera_zoom_out"):
			$debugCam.zoom += Vector2(1,1)
		if Input.is_action_pressed("debug_camera_activate"):
			#$CanvasModulate.visible = !$CanvasModulate.visible
			if($debugCam.current):
				$debugCam.current = false
				$Player/PlayerCamera.current = true
			else:
				$Player/PlayerCamera.current = false
				$debugCam.current = true
#	Takes in a position(Vec2) and checks if it is a valid tile to move to
func _tile_Check(position):
	var dungeonPosition = Dungeon.get_cellv(Dungeon.world_to_map(position))
	var check
	if(enemyCheck(position)):
		$TurnTimer.start()
		return false
	Log.logInfo(Player.getInfo().Name + " moved!")
	check = (dungeonPosition == 0 or dungeonPosition == 1)
	if(dungeonPosition == 0):
		Dungeon.set_cellv(Dungeon.world_to_map(position),1)
	return check
	#Basic Movement Handling

func playerMovementHandler(direction, position):
	var tempPos = position
	if(direction == 0):
		tempPos.x -= 32
		if(_tile_Check(tempPos)):
			if(PlayerSprite.flip_h != true):
				PlayerSprite.flip_h = true
			Player.move(tempPos)
		else: return
	if(direction == 1):
		if(PlayerSprite.flip_h != false):
				PlayerSprite.flip_h = false
		tempPos.x += 32
		if(_tile_Check(tempPos)):
			Player.move(tempPos)
		else: return
	if(direction == 2):
		tempPos.y -= 32
		if(_tile_Check(tempPos)):
			Player.move(tempPos)
		else: return
	if(direction == 3):
		tempPos.y += 32
		if(_tile_Check(tempPos)):
			Player.move(tempPos)
		else: return
	$TurnTimer.start()

func enemyCheck(position):
	for i in Dungeon.getEnemies():
		var enemyPosition = Dungeon.world_to_map(i.getPosition())
		var newPlayerPosition = Dungeon.world_to_map(position)
		if (newPlayerPosition == enemyPosition ):			
			Log.logInfo(Player.getInfo().Name + " attacks " + i.getInfo().Name,1)
			if(attackEnemy(i)):
				print(true)
				Dungeon.getEnemies().erase(i)
			return true
	return false
#	Calculates tile in direction passed, 32units from player
func createMainMenu():
	var displayMain = mainMenuPre.instance()
	$UI.add_child(displayMain)
	return displayMain

func menuPlayButton():
	rng.randomize()
	mapSize = Vector2(rng.randi_range(100,200),rng.randi_range(100,200))
	maxRooms = (mapSize.x+mapSize.y/5)
	print(mapSize)
	Player.createCharacter("Alexander",0)
	Player.position = Dungeon.generateLevel(mapSize,maxRooms,rng)
	UI.visible = true
	Dungeon.visible = true
	Player.visible = true
	PlayerCamera.current = true
	playerTurn = true
	mainMenu.queue_free()

func attackEnemy(enemy):
	var damage = Player.getInfo().Stats.STR
	if(enemy.takeDamage(damage)):
		return true
		
func onDeath(name):
	print(name)
	Log.logInfo(Player.getInfo().Name + " kills " + name + '!',1)
	
func _on_Player_playerMove(direction,position):
	if(playerTurn):
		playerMovementHandler(direction, position)
#	Itterate through enemies in tree. Once reaching end set playerTurn true
#	Check enemy 'seen' value. If visible lerp animation. Otherwise move 
#   directly to target location if valid movement.

func enemyTurn():
	for i in Dungeon.getEnemies():
		var direction = rng.randi_range(0,3)
		enemyTileCheck(direction,i)	
	$TurnTimer.start()

func enemyTileCheck(direction,i):
	if direction == 0:
		var world = i.position - Vector2(32,0)
		for j in Dungeon.getEnemies():
			if(j != i):
				if(j.position == i.position):	
					return
		var tile = Dungeon.get_cellv(Dungeon.world_to_map(world))
		if(world == Player.position):
			print("ATTACK!")
		else:
			i.move(world,tile)
	elif direction == 1:
		var world = i.position + Vector2(32,0)
		for j in Dungeon.getEnemies():
			if(j != i):
				if(j.position == i.position):
					return
		var tile = Dungeon.get_cellv(Dungeon.world_to_map(world))
		if(world == Player.position):
			print("ATTACK!")
		else:
			i.move(world,tile)
	elif direction == 2:
		var world = i.position - Vector2(0,32)
		for j in Dungeon.getEnemies():
			if(j != i):
				if(j.position == i.position):
					return
		var tile = Dungeon.get_cellv(Dungeon.world_to_map(world))
		if(world == Player.position):
			print("ATTACK!")
		else:
			i.move(world,tile)
	elif direction == 3:
		var world = i.position + Vector2(0,32)
		for j in Dungeon.getEnemies():
			if(j != i):
				if(j.position == i.position):
					return
		var tile = Dungeon.get_cellv(Dungeon.world_to_map(world))
		if(world == Player.position):
			print("ATTACK!")
		else:
			i.move(world,tile)
			
func _on_TurnTimer_timeout():
	playerTurn = !playerTurn
	enemyTurn = !enemyTurn
	if(enemyTurn):
		enemyTurn()
	else:
		print("Going to player turn")
	
