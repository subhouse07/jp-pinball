extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


#func _on_TrapDoor_door_timed_out(x, y):
#


func _on_Timer_timeout():
	_disable_collision()
#	_move_doorman()


func _on_TrapDoor_ball_trapped():
	$Timer.start()

func _disable_collision():
	$DoorBlock.collision_layer = 0
	$DoorBlock.collision_mask = 0
	$Doorman.collision_layer = 0
	$Doorman.collision_mask = 0
	$TrapDoor/Area2D.collision_layer = 0
	$TrapDoor/Area2D.collision_mask = 0
	
#func _move_doorman():
	# trigger sprite animation to move to desk
	
