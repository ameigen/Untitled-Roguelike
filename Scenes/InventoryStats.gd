extends Control

signal tempButton
onready var menuName = $Background/Name
onready var menuHealth = $Background/Health
onready var menuStats = $Background/Stats
onready var menuWeight = $Background/Weight
onready var menuJob = $Background/Name/Job
var jobs = ["Warrior"]
func _ready():
	connect("tempButton",get_parent(),"_on_tempButton")
	
func on_receive_playerInfo(pInfo):
	print("test")
	menuName.text = ("Name: " + pInfo.Name)
	menuJob.text = ("Job: " + jobs[pInfo.Job])
	menuHealth.text = ("Health: " + str(pInfo.CurrentHealth) + '/' + str(pInfo.MaxHealth))
	menuWeight.text = ("Max Weight: " + str(pInfo.Weight))
	menuStats.text = ""
	for i in pInfo.Stats:
		menuStats.text += (i + ': ' + str(pInfo.Stats[i]) + '\n')
	
func _on_inventoryButton_pressed():
	emit_signal("tempButton")

