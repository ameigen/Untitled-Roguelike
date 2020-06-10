extends CanvasLayer

signal hudUpdate
signal menuUpdate
var subMenu = preload("res://Scenes/InventoryStats.tscn")
var menu
var playerInfo
func _ready():
	pass
	
func _process(delta):
	pass
	
func _on_Button_pressed():
	menu = subMenu.instance()
	add_child(menu)
	self.connect("menuUpdate",menu,"on_receive_playerInfo")
	emit_signal("menuUpdate",playerInfo)

func _on_tempButton():
	menu.queue_free()
	print(menu)

func _on_Player_passPlayerInfo(pInfo):
	emit_signal("hudUpdate",pInfo)
	playerInfo = pInfo
	
