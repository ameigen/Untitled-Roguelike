extends Label

var debugString

func _ready():
	pass
	
func _process(delta):
	self.text = debugString

func _on_Debug_debugOut(debug):
	debugString = debug
