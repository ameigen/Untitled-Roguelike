extends Area2D
signal playerMove
signal passPlayerInfo
signal movementFinished
onready var PTween = $PlayerTween
var pName = ""
var stats = {"STR": 0,"DEX": 0,"CON": 0,"INT": 0,"WIS": 0,"CHA": 0, "LCK": 0}
var playerInfo = {
	"Name" : "", "MaxHealth" : 110,"CurrentHealth" : 110, "Mana" : 0, "Job" : 0, "Inventory" : [], "Stats" : stats, "Statuses" : [], "Weight" : 0}


#	enum for cardinal directions
enum DIRECTIONS {LEFT, RIGHT, UP, DOWN}

func _ready():
	pass
#	If input event, send direction and position as signal
func _unhandled_key_input(event):
	if Input.is_action_pressed("ui_left"): 
		emit_signal("playerMove",DIRECTIONS.LEFT,position)
	if Input.is_action_pressed("ui_right"):
		emit_signal("playerMove",DIRECTIONS.RIGHT,position)
	if Input.is_action_pressed("ui_up"):
		emit_signal("playerMove",DIRECTIONS.UP,position)
	if Input.is_action_pressed("ui_down"):
		emit_signal("playerMove",DIRECTIONS.DOWN,position)
		
func createCharacter(name,jobTemp):
	playerInfo.Name = name
	if(jobTemp == 0):
		playerInfo.Job = 0
		var tempstats = [10,10,10,5,5,5,5]
		var count = 0
		for i in playerInfo.Stats:
			playerInfo.Stats[i] = tempstats[count]
			count += 1
	playerInfo.Weight = playerInfo.Stats.STR*10+playerInfo.Stats.CON 
	playerInfo.MaxHealth = playerInfo.Stats.CON*10
	playerInfo.CurrentHealth = playerInfo.MaxHealth
	emit_signal("passPlayerInfo",playerInfo)
	set_process_input(true)

func move(end):
	PTween.interpolate_property(self,"position",position,end,1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	PTween.start()

func getInfo():
	return playerInfo

func getHealth():
	return playerInfo.CurrentHealth

func getAttacked(attacker):
	pass

