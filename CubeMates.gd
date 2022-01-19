extends Node2D

const tasks = {
	"copier": "CopierSection",
	"files": "FileCabinets",
	"brain": "Brainstorm"
}

signal desk_ball_trapped
signal desk_ball_released(x, y)
signal task_activated(area, name)


func _ready():
	_set_bumpers_enabled($"/root/GameState".cube_task_active)


func _on_TrapDoor_ball_trapped():
	emit_signal("desk_ball_trapped")
	var area = $"/root/GameState".AREA_CUBE
	if $"/root/GameState".brainstorm_ready():
		emit_signal("task_activated", area, tasks["brain"])
		$"/root/GameState".cube_task_ind = 2
		$"/root/GameState".cube_task_active = true
	elif $"/root/GameState".cube_task_ind > 0:
		emit_signal("task_activated", area, tasks["copier"])
		$"/root/GameState".cube_task_ind = 0
		$"/root/GameState".cube_task_active = true
	else:
		emit_signal("task_activated", area, tasks["files"])
		$"/root/GameState".cube_task_ind += 1
		$"/root/GameState".cube_task_active = true


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

func reset():
	$"/root/GameState".cube_task_active = false
	_set_bumpers_enabled(false)
