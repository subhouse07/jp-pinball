extends Node2D

const TASKS = {
	"copier": "CopierSection",
	"files": "FileCabinets",
	"brain": "Brainstorm"
}

var capturing_mate : Node2D
var task : String

signal task_activated(area, name)
signal dialog_activated(character_id)


func _ready():
	_set_bumpers_enabled($"/root/GameState".cube_task_active)


func _on_TrapDoor_ball_trapped(right_mate_captured: bool):
	if right_mate_captured:
		capturing_mate = $RightCubeMate
	else:
		capturing_mate = $LeftCubeMate
	_select_task()
	emit_signal("dialog_activated", Constants.CHAR_ID_CM)


func on_dialog_freed():
	GameState.score(self.name)
	_set_bumpers_enabled(true)
	$RightCubeMate.set_enabled(false)
	$LeftCubeMate.set_enabled(false)
	capturing_mate.release_ball()
	emit_signal("task_activated", GameState.AREA_CUBE, task)


func _select_task():
#	var area = $"/root/GameState".AREA_CUBE
	if GameState.brainstorm_ready():
#		emit_signal("task_activated", area, TASKS["brain"])
		GameState.cube_task_ind = 2
		GameState.cube_task_active = true
		task = TASKS["brain"]
	elif GameState.cube_task_ind > 0:
#		emit_signal("task_activated", area, TASKS["copier"])
		GameState.cube_task_ind = 0
		GameState.cube_task_active = true
		task = TASKS["copier"]
	else:
#		emit_signal("task_activated", area, TASKS["files"])
		GameState.cube_task_ind = 1
		GameState.cube_task_active = true
		task = TASKS["files"]


func _set_bumpers_enabled(enabled : bool):
	$RightCubeMate.set_enabled(!enabled)
	$LeftCubeMate.set_enabled(!enabled)
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


func _on_DeskBumper_body_entered(body):
	if body.name == "Ball":
		GameState.score("CubicleBumper")
