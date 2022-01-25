extends Node2D

const tasks = {
	"copier": "CopierSection",
	"files": "FileCabinets",
	"brain": "Brainstorm"
}

var capturing_mate : Node2D

signal task_activated(area, name)
signal dialog_activated(character_id)


func _ready():
	_set_bumpers_enabled($"/root/GameState".cube_task_active)


func _on_TrapDoor_ball_trapped(right_mate_captured: bool):
	if right_mate_captured:
		capturing_mate = $RightCubeMate
	else:
		capturing_mate = $LeftCubeMate
	emit_signal("dialog_activated", Constants.CHAR_ID_CM)


func on_dialog_freed():
	GameState.score(self.name)
	_set_bumpers_enabled(true)
	$RightCubeMate.set_enabled(false)
	$LeftCubeMate.set_enabled(false)
	capturing_mate.release_ball()


func _select_task():
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
