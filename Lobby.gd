extends Node2D

enum { NETWORK, LUNCH, TRAFFIC, CENTER }

var special_triggered : int
var entrance_enabled = false

signal special_entered(special_name)

func _ready():
	pass

func activate_special_stage(task: int):
	match task:
		NETWORK:
			pass
		LUNCH:
			pass
		TRAFFIC:
			pass
		CENTER:
			pass

func activate_task():
	# Placeholder until task stuff is in place
	pass
