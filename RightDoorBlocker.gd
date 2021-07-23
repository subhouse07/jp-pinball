extends Node2D

var res_door_open
var res_door_closed

# Called when the node enters the scene tree for the first time.
func _ready():
	res_door_open = preload("res://right-door-open.png")
	res_door_closed = preload("res://right-door-closed.png")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


#func _on_TrapDoor_door_timed_out(x, y):
#


func _on_TrapDoor_ball_trapped():
	$TrapDoorTimer.start()

func _disable_collision():
	$DoorBlock.collision_layer = 0
	$DoorBlock.collision_mask = 0
	$Doorman.collision_layer = 0
	$Doorman.collision_mask = 0
	$TrapDoor/Area2D.collision_layer = 0
	$TrapDoor/Area2D.collision_mask = 0
	
#func _move_doorman():
	# trigger sprite animation to move to desk
	


func _on_RightDoorArea_body_entered(body):
	if body.name == "Ball" and $FrontDoorTimer.time_left == 0:
		print("timer start")
		$FrontDoorTimer.start()


func _on_TrapDoorTimer_timeout():
	_disable_collision()


func _on_FrontDoorTimer_timeout():
	$DoorSprite.texture = res_door_open
	$RightDoorBody.collision_layer = 0
	$RightDoorBody.collision_mask = 0
	$CloseFrontDoorTimer.start()


func _on_CloseFrontDoorTimer_timeout():
	$DoorSprite.texture = res_door_closed
	$RightDoorBody.collision_layer = 1
	$RightDoorBody.collision_mask = 1
