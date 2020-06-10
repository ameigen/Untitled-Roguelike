extends Control

signal tempButton
onready var menuName = $Background/Name
onready var menuHealth = $Background/Health
onready var menuStats = $Background/Stats
onready var menuWeight = $Background/Weight

func _ready():
	connect("tempButton",get_parent(),"_on_tempButton")
	
func on_receive_playerInfo(pInfo):
	print("test")
	menuName.text += pInfo.Name
	menuHealth.text += str(pInfo.Health)
	menuWeight.text += str(pInfo.Weight)
	for i in pInfo.Stats:
		menuStats.text += (i + ': ' + str(pInfo.Stats[i]) + '\n')
	
func _on_inventoryButton_pressed():
	emit_signal("tempButton")

