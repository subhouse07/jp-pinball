extends Node2D

var res_frontdoor_open
var res_frontdoor_close

var velocity = Vector2(0,0)

var launched = false
var trapped = false
var trapped_position := Vector2()
var teleporting = false
var tele_coords := Vector2()
var tele_speed = 50

var ball_in_launcher = false
var ball_in_elevator = false
var courier_captured = false
var elevator_open = false


# Called when the node enters the scene tree for the first time.
func _ready():
	res_frontdoor_open = preload("res://table-front-door-open.png")
	res_frontdoor_close = preload("res://table-front-door-closed.png")
#	$CenterPiece/AnimationPlayer.play("New Anim")
	
	# more logic needed for this obviously
#	$Ball.global_position = GameState.main_board_ball_pos
	

#func _process(delta):
#	pass
	
		
	
#	if teleporting:
#		if $Ball.global_position != tele_coords:
#			$Ball.linear_velocity = $Ball.position.angle_to(tele_coords)
		

func _physics_process(delta):
	if ball_in_launcher:
		$Ball.global_position = $Launcher/Path2D/PathFollow2D.global_position
		
	if trapped:
		$Ball.global_position = trapped_position
	
	if courier_captured:
		$Ball.global_position = $CourierCoordinator.capture_coords
		
	if ball_in_elevator:
		$Ball.global_position.y = $Elevator.global_position.y

func _on_TrapDoor_ball_trapped():
	$Ball.hide()
	$Ball.mode = RigidBody2D.MODE_KINEMATIC
	trapped = true
	trapped_position = $Ball.global_position
	
#	if $TrapDoor.is_teleport:
##		$Ball.set_physics_process(false)
#		teleporting = true
##		tele_coords = Vector2(100, -400)
#		$TeleportTimer.start()
	


func _on_TrapDoor_door_timed_out(x, y):
	trapped = false
	$Ball.linear_velocity = Vector2(0,0)
	$Ball.angular_velocity = 0
	$Ball.mode = RigidBody2D.MODE_CHARACTER
	$Ball.apply_central_impulse(Vector2(x, y))
	$Ball.show()


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
	$Ball.mode = RigidBody2D.MODE_CHARACTER
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


func _on_YourOfficeArea2D_body_entered(body):
	if body.name == "Ball":
		$AnimatedSprite2.play("idle_1")


func _on_YourOfficeArea2D_body_exited(body):
	if body.name == "Ball":
		$AnimatedSprite2.play("idle_1", true)

func _on_ComputerDoor_door_timed_out(x, y):
#	GameState.call("hit_computer")
#	if GameState.hp_computer == 0:
#		GameState.main_board_ball_pos = $Ball.global_position
#		GameState.reset_hp_computer()
#		get_parent().call("load_scene", "SpecialTest")
#	else:
	_on_TrapDoor_door_timed_out(x, y)
	
func _on_CourierCoordinator_ball_captured():
	$Ball.global_position
	$Ball.mode = RigidBody2D.MODE_KINEMATIC
	courier_captured = true

func _on_CourierCoordinator_ball_released():
	courier_captured = false
	$Ball.global_position = $CourierCoordinator.capture_coords
	$Ball.linear_velocity = Vector2(0,0)
	$Ball.angular_velocity = 0
	$Ball.mode = RigidBody2D.MODE_CHARACTER
	$Ball.apply_central_impulse(Vector2(100, 0))


func _on_ElevatorDoorArea_body_entered(body):
	if body.name == "Ball":
		if elevator_open:
			
			$Ball.hide()
			$Ball.global_position
			$Ball.mode = RigidBody2D.MODE_KINEMATIC
			$Ball.collision_layer = 0
			$Ball.collision_mask = 0
			ball_in_elevator = true
			elevator_open = false 
			$Elevator.go_to_cubicle()
			$ElevatorDoor/AnimatedSprite.play("close")
		else:
			elevator_open = true
			$Elevator.go_to_lobby()
			$ElevatorDoor/AnimatedSprite.play("open")


func _on_Elevator_cubicle_reached():
	ball_in_elevator = false
	_disable_door_collision()
	$Ball.show()
	$Ball.collision_layer = 1
	$Ball.collision_mask = 1
	$Ball.linear_velocity = Vector2(0,0)
	$Ball.angular_velocity = 0
	$Ball.mode = RigidBody2D.MODE_CHARACTER
	$Ball.apply_central_impulse(Vector2(150, 30))
	
func _disable_door_collision():
	$ElevatorDoor2/CollisionPolygon2D.disabled = true
	$ElevatorDoor2/Timer.start()


func _on_ElevatorDoorTimer_timeout():
	$ElevatorDoor2/CollisionPolygon2D.disabled = false
