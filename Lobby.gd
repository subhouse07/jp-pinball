extends Node2D

var special_triggered : int
var entrance_enabled = false

signal special_entered(special_name)

func _ready():
	pass

func activate_special_stage():
	print("Congrats the special stage %s is available" % Constants.LOBBY_TASKS[GameState.lobby_task_ind])
	GameState.lobby_task_active = false

func activate_task():
	pass
	# this function will probably light up some target indicators depending on
	# the task. It will also open up the door to the basement, as well as open 
	# the side road entrance to the traffic special stage
