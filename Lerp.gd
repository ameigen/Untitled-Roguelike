extends Node

onready var startTime
#sets delay before lerp function jumps object to location (milliseconds)
export var lerpDelay = 100
var endLocation
var target
var t = 0

signal lerpFinished

#	Disable processing on scene enter.
func _ready():
	set_process(false)

func startLerp():
	startTime = OS.get_ticks_msec()
	set_process(true)

#	Called by external, takes an end Vec2 and target node
#	will set start processing and set local variables
func lerpToSpot(moveVec, object):
	endLocation = moveVec
	target = object
	startLerp()

#Handles lerp to target space. If lerpDelay is passed before 
#object position = target position we set the positions equal.
func _process(delta):
	if(target.position == endLocation):
		t = 0
		print("lerpingfinished")
		emit_signal("lerpFinished")
		set_process(false)
	else:
		if(OS.get_ticks_msec() - startTime > lerpDelay):
			target.position = endLocation
			t = 0
		else:	
			t += delta *1
			target.position = target.position.linear_interpolate(endLocation,t)
