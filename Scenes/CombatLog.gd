extends Label

var open = false
onready var Log = $CombatLogInterior
func _ready():
	pass # Replace with function body.

func _on_LogButton_pressed():
	if(!open):
		rect_position.y = -118
		rect_size.y = 118
		Log.visible = true
		open = !open
	else:
		rect_position.y = -19
		rect_size.y = 19
		Log.visible = false
		open = !open

func logInfo(information, flag = 0):
	if(Log.get_line_count() >= 100):
		Log.remove_line(0)
		Log.newLine()
	if(flag == 0):
		Log.add_text(information + '\n')
	if(flag == 1):
		Log.push_color(Color(1,0,0))
		Log.add_text(information + '\n')
	
	Log.push_color(Color(1,1,1))
