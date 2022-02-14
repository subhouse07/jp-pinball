extends Node2D

var special_triggered : int
var entrance_enabled = false

signal special_entered(special_name)

func _ready():
	pass

func activate_special_stage():
	entrance_enabled = true

func activate_task():
	match GameState.lobby_task_ind:
		Constants.TRAFFIC:
			$TrafficTask.activate()
		Constants.LUNCH:
			pass
		Constants.NETWORK:
			pass
		Constants.BASEMENT:
			$CenterPiece.activate_entrance()
	# this function will probably light up some target indicators depending on
	# the task. It will also open up the door to the basement, as well as open 
	# the side road entrance to the traffic special stage


func _on_TrafficTask_traffic_special_entered():
	emit_signal("special_entered", Constants.SP_NAME_TRAFFIC)


func _on_TimeClockDoor_ball_trapped():
	if entrance_enabled:
		GameState.lobby_task_active = false
		if GameState.lobby_task_ind == Constants.LUNCH:
			emit_signal("special_entered", Constants.SP_NAME_LUNCH)
		else:
			emit_signal("special_entered", Constants.SP_NAME_NETWORK)
