extends Node2D

func _ready():
	pass # Replace with function body.

func _process(delta):
	position.y -= .025
	
func displayDamage(damage):
	$Label.text = str(damage)
	set_process(true)
	$Timer.start()

func _on_Timer_timeout():
	queue_free()
