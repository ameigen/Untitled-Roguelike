extends Area2D
signal playerMove

#	enum for cardinal directions
enum DIRECTIONS {LEFT, RIGHT, UP, DOWN}

func _ready():
	set_process_input(true)

#	If input event, send direction and position as signal
func _input(event):
	if Input.is_action_pressed("ui_left"): 
		emit_signal("playerMove",DIRECTIONS.LEFT,self.position)
	if Input.is_action_pressed("ui_right"):
		emit_signal("playerMove",DIRECTIONS.RIGHT,self.position)
	if Input.is_action_pressed("ui_up"):
		emit_signal("playerMove",DIRECTIONS.UP,self.position)
	if Input.is_action_pressed("ui_down"):
		emit_signal("playerMove",DIRECTIONS.DOWN,self.position)
