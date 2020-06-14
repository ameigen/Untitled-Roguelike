extends ColorRect
var health = 100
var curHealth
var healthUnit = health/self.rect_size.x

func _ready():
	$HealthAmt.text = (str(curHealth) + '/' + str(health))


func updateHUD():
	$HealthAmt.text = (str(curHealth) + '/' + str(health))
	
func _on_Game_takeDamage(damage):
	rect_size.x -= (healthUnit * damage)
	curHealth -= damage
	updateHUD()

func _on_UI_hudUpdate(pInfo):
	health = pInfo.MaxHealth
	curHealth = pInfo.CurrentHealth
	healthUnit = health/self.rect_size.x
	updateHUD()
	
