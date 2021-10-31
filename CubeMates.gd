extends Node2D

const tasks = {
	"copier": "CopierSection",
	"files": "",
	"brainstorm": ""
}

signal desk_ball_trapped
signal desk_ball_released(x, y)
signal task_activated(name)


func _ready():
	_set_bumpers_enabled(false)


func _on_TrapDoor_ball_trapped():
	emit_signal("desk_ball_trapped")
	emit_signal("task_activated", tasks["copier"])


func _on_TrapDoor_door_timed_out(x, y):
	emit_signal("desk_ball_released", x, y)
	_set_bumpers_enabled(true)
	$TrapDoor.set_enabled(false)
	$TrapDoor2.set_enabled(false)


func _set_bumpers_enabled(enabled : bool):
	$TrapDoor.set_enabled(!enabled)
	$TrapDoor2.set_enabled(!enabled)
	if enabled:
		$LeftDesk.collision_layer = 1
		$LeftDesk.collision_mask = 1
		$RightDesk.collision_layer = 1
		$RightDesk.collision_mask = 1
	else:
		$LeftDesk.collision_layer = 0
		$LeftDesk.collision_mask = 0
		$RightDesk.collision_layer = 0
		$RightDesk.collision_mask = 0
	
