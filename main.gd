extends Node2D

var res_frontdoor_open
var res_frontdoor_close

var velocity = Vector2(0,0)

var launched = false
var teleporting = false
var tele_coords := Vector2()
var tele_speed = 50

var ball_in_launcher = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	res_frontdoor_open = preload("res://table-front-door-open.png")
	res_frontdoor_close = preload("res://table-front-door-closed.png")
	$CenterPiece/AnimationPlayer.play("New Anim")
	

func _process(delta):
	
	if ball_in_launcher:
		$Ball.global_position = $Launcher/Path2D/PathFollow2D.global_position
		
	
#	if teleporting:
#		if $Ball.global_position != tele_coords:
#			$Ball.linear_velocity = $Ball.position.angle_to(tele_coords)
		

func _physics_process(delta):
	pass


#func _on_TrapDoor_ball_trapped():
#	$Ball.hide()
#	$Ball.sleeping = true
#	if $TrapDoor.is_teleport:
##		$Ball.set_physics_process(false)
#		teleporting = true
##		tele_coords = Vector2(100, -400)
#		$TeleportTimer.start()
	


#func _on_TrapDoor_door_timed_out():
#	$Ball.sleeping = false
#	$Ball.apply_central_impulse(Vector2(120, 240))
#	$Ball.show()


#func _on_TeleportTimer_timeout():
#	$Ball.global_position = tele_coords
#	$Ball.sleeping = false
#	$Ball.show()
#
#
#func _on_TeleportHole_teleport_entered(coords):
#	$Ball.hide()
#	$Ball.sleeping = true
#	teleporting = true
#	tele_coords = coords
#	$TeleportTimer.start()

func _on_Launcher_ball_captured():
	$Ball.mode = RigidBody2D.MODE_KINEMATIC
#	$Ball/Camera2D.current = false
	ball_in_launcher = true

func _on_Launcher_ball_disembarked(coords, early_disembark):
	ball_in_launcher = false
	$Ball.global_position = coords
	$Ball.linear_velocity = Vector2(0,0)
	$Ball.angular_velocity = 0
#	$Ball.sleeping = false
	
#	$Ball.show()
	$Ball.mode = RigidBody2D.MODE_RIGID
#	$Ball/Camera2D.current = true
	if early_disembark:
		$Ball.apply_central_impulse(Vector2(-250, -250))
	else:
		$Ball.apply_central_impulse(Vector2(-150, 0))
	


func _on_SlowDownArea_body_entered(body):
	if body.name == "Ball":
		print("ball entered")
		

func _on_SlowDownArea_body_exited(body):
	if body.name == "Ball":
		print("ball exited")



# replace with animations
func _on_FrontDoorArea_body_entered(body):
	if body.name == "Ball":
		$FrontDoorArea/Door.texture = res_frontdoor_open


func _on_FrontDoorArea_body_exited(body):
	if body.name == "Ball":
		$FrontDoorArea/Door.texture = res_frontdoor_close
