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


func _on_OfficeAdmin_ball_entered():
	print("OA encountered. Resetting OA")
	$OfficeAdmin.set_office_admin_enabled(false)
	print("No tasks available now, so resetting desk state")
	$OfficeAdmin.reset_desks()
