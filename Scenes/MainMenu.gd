extends Control

signal playButton
signal optionsButton
signal creditsButton
signal unlockablesButton
signal leaderboardsButton
signal exitButton

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("playButton",get_parent(),"menuPlayButton")
	connect("optionsButton",get_parent(),"menuOptionsButton")
	connect("creditsButton",get_parent(),"menuCreditsButton")
	connect("unlockablesButton",get_parent(),"menuUnlockablesButton")
	connect("leaderboardsButton",get_parent(),"menuLeaderboardsButton")
	connect("exitButton",get_parent(),"menuExitButton")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
