extends Label

func _ready():
	pass # Replace with function body.

func _on_UI_hudUpdate(pInfo):
	text = ("Name: " + str(pInfo.Name))
