extends ColorRect
var health = 100
var curHealth
var healthUnit = health/self.rect_size.x

func _ready():
	$HealthAmt.text = (str(curHealth) + '/' + str(health))

func _on_Game_takeDamage(damage):
	rect_size.x -= (healthUnit * damage)
	curHealth -= damage
	$HealthAmt.text = (str(curHealth) + '/' + str(health))

func _on_UI_hudUpdate(pInfo):
	health = pInfo.MaxHealth
	healthUnit = health/self.rect_size.x
	
