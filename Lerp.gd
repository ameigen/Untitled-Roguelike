extends Node

var endLocation
var target
var t = 0
signal lerpFinished

func _ready():
	set_process(false)

func startLerp():
	set_process(true)

func lerpToSpot(moveVec, object):
	endLocation = moveVec
	target = object
	startLerp()

func _process(delta):
	if(target.position == endLocation):
		t = 0
		emit_signal("lerpFinished")
		set_process(false)
	else:
		t += delta *1
		target.position = target.position.linear_interpolate(endLocation,t)
