extends Node2D

signal enemyDeath
var enemySeen = true
enum ENEMYTYPE {HUMANOID, INSECT, FAE, BEAST, MONSTROSITY}
var enemyStats = {
	"Name" : "", "Health" : 0,"Damage" : 0, "Type" : 0, "Drops" : [], "Defense" : 0, "Evasion" : 0, "Statuses" : [],"EXP": 0}
var enemyPosition = Vector2()
onready var enemySprite = $EnemyArea/EnemySprite
onready var enemyNamePlate = $EnemyArea/EnemyName
onready var enemyTween = $EnemyTween

func _ready():
	connect("enemyDeath",.get_parent().get_parent(),"onDeath")

func createEnemy(rng,spawn):
	var enemyID = rng.randi_range(0,2)
	if(enemyID == 0):
		enemySprite.animation = "goblin"
		enemyStats.Name = "GOBBO"
		enemyStats.Health = 5
		enemyStats.Damage = 10
		enemyStats.Evasion = 1
		enemyStats.Defense = 0
		enemyStats.Type = ENEMYTYPE.HUMANOID
	if(enemyID == 1):
		enemySprite.animation = "fairy"
		enemyStats.Name = "TINKLE"
		enemyNamePlate.text = enemyStats.Name
		enemyStats.Damage = 5
		enemyStats.Evasion = 3
		enemyStats.Defense = -2
		enemyStats.Health = 5
		enemyStats.Type = ENEMYTYPE.FAE
	if(enemyID == 2):
		enemySprite.animation = "orc"
		enemyStats.Name = "GORK"
		enemyNamePlate.text = enemyStats.Name
		enemyStats.Damage = 15
		enemyStats.Evasion = 0
		enemyStats.Defense = 3
		enemyStats.Health = 15
		enemyStats.Type = ENEMYTYPE.HUMANOID
	enemyNamePlate.text = enemyStats.Name
	position = spawn
	enemyPosition = spawn
		
func getPosition():
	return position

func killFree():
	queue_free()
	
func getInfo():
	return enemyStats

func checkSeen():
	return enemySeen
	
func move(endWorld,endTile):
	if(enemySeen):
		if(endTile != 2 and endTile != -1):
			enemyTween.interpolate_property(self,"position",position,endWorld,1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
			enemyTween.start()
	else:
		position = endWorld
		
func takeDamage(damage):
	enemyStats.Health -= damage
	if(enemyStats.Health <= 0):
		emit_signal("enemyDeath", enemyStats.Name)
		queue_free()
		return true

func _on_EnemyTween_tween_completed(object, key):
	pass # Replace with function body.
