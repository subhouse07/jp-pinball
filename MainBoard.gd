extends Node2D

const MAINLVL_MASK = 1
const MAINLVL_LAYER = 1
const SUBLVL_MASK = 2
const SUBLVL_LAYER = 2

onready var sublvl_shader = preload("res://Peephole.shader");
var bg_dimen : Vector2

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
var ball_in_sublvl = false
var courier_captured = false
var elevator_open = false

var ball : RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	ball = $YSort/Ball
	res_frontdoor_open = preload("res://table-front-door-open.png")
	res_frontdoor_close = preload("res://table-front-door-closed.png")
	bg_dimen = Vector2($Background.texture.get_width()*$Background.scale.x, \
		$Background.texture.get_height()*$Background.scale.y)
#	$CenterPiece/AnimationPlayer.play("New Anim")
	
	# more logic needed for this obviously
#	ball.global_position = GameState.main_board_ball_pos
	

func _process(delta):
	if ball_in_sublvl:
		$Background.material.set_shader_param("objPos", ball.global_position)

#	if teleporting:
#		if ball.global_position != tele_coords:
#			ball.linear_velocity = ball.position.angle_to(tele_coords)
		

func _physics_process(delta):
	if ball_in_launcher:
		ball.global_position = $Launcher/Path2D/PathFollow2D.global_position
		
	if trapped:
		ball.global_position = trapped_position
	
	if courier_captured:
		ball.global_position = $CourierCoordinator.capture_coords
		
	if ball_in_elevator:
		ball.global_position.y = $Elevator.global_position.y

func _on_TrapDoor_ball_trapped():
	ball.hide()
	ball.mode = RigidBody2D.MODE_KINEMATIC
	trapped = true
	trapped_position = ball.global_position
	
#	if $TrapDoor.is_teleport:
##		ball.set_physics_process(false)
#		teleporting = true
##		tele_coords = Vector2(100, -400)
#		$TeleportTimer.start()
	


func _on_TrapDoor_door_timed_out(x, y):
	trapped = false
	ball.linear_velocity = Vector2(0,0)
	ball.angular_velocity = 0
	ball.mode = RigidBody2D.MODE_CHARACTER
	ball.apply_central_impulse(Vector2(x, y))
	ball.show()


#func _on_TeleportTimer_timeout():
#	ball.global_position = tele_coords
#	ball.sleeping = false
#	ball.show()
#
#
#func _on_TeleportHole_teleport_entered(coords):
#	ball.hide()
#	ball.sleeping = true
#	teleporting = true
#	tele_coords = coords
#	$TeleportTimer.start()

func _on_Launcher_ball_captured():
	get_tree().call_group("ball_resets", "reset")
	ball.mode = RigidBody2D.MODE_KINEMATIC
	ball.hide()
	ball_in_launcher = true

func _on_Launcher_ball_disembarked(coords, early_disembark):
	ball_in_launcher = false
	ball.show()
	ball.global_position = coords
	ball.linear_velocity = Vector2(0,0)
	ball.angular_velocity = 0
	ball.mode = RigidBody2D.MODE_CHARACTER
	if early_disembark:
		ball.apply_central_impulse(Vector2(-250, -250))
	else:
		ball.apply_central_impulse(Vector2(-150, 0))
	


func _on_SlowDownArea_body_entered(body):
	if body.name == "Ball":
		print("ball entered")
		

func _on_SlowDownArea_body_exited(body):
	if body.name == "Ball":
		print("ball exited")



# replace with animations
func _on_FrontDoorArea_body_entered(body):
	if body.name == "Ball":
		$YSort/FrontDoorArea/Door.texture = res_frontdoor_open


func _on_FrontDoorArea_body_exited(body):
	if body.name == "Ball":
		$YSort/FrontDoorArea/Door.texture = res_frontdoor_close


func _on_YourOfficeArea2D_body_entered(body):
	if body.name == "Ball":
		$AnimatedSprite2.play("idle_1")


func _on_YourOfficeArea2D_body_exited(body):
	if body.name == "Ball":
		$AnimatedSprite2.play("idle_1", true)

func _on_ComputerDoor_door_timed_out(x, y):
#	GameState.call("hit_computer")
#	if GameState.hp_computer == 0:
#		GameState.main_board_ball_pos = ball.global_position
#		GameState.reset_hp_computer()
#		get_parent().call("load_scene", "SpecialTest")
#	else:
	_on_TrapDoor_door_timed_out(x, y)
	
func _on_CourierCoordinator_ball_captured():
	ball.global_position
	ball.mode = RigidBody2D.MODE_KINEMATIC
	courier_captured = true

func _on_CourierCoordinator_ball_released():
	courier_captured = false
	ball.global_position = $CourierCoordinator.capture_coords
	ball.linear_velocity = Vector2(0,0)
	ball.angular_velocity = 0
	ball.mode = RigidBody2D.MODE_CHARACTER
	ball.apply_central_impulse(Vector2(100, 0))


func _on_ElevatorDoorArea_body_entered(body):
	if body.name == "Ball":
		if elevator_open:
			
			ball.hide()
			ball.global_position
			ball.mode = RigidBody2D.MODE_KINEMATIC
			ball.collision_layer = 0
			ball.collision_mask = 0
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
	ball.show()
	ball.collision_layer = 1
	ball.collision_mask = 1
	ball.linear_velocity = Vector2(0,0)
	ball.angular_velocity = 0
	ball.mode = RigidBody2D.MODE_CHARACTER
	ball.apply_central_impulse(Vector2(150, 30))
	
func _disable_door_collision():
	$ElevatorDoor2/CollisionPolygon2D.disabled = true
	$ElevatorDoor2/Timer.start()


func _on_ElevatorDoorTimer_timeout():
	$ElevatorDoor2/CollisionPolygon2D.disabled = false


func _on_SubEntrArea_body_entered(body, entering_sublvl):
	if body.name == "Ball" and !courier_captured:
		_set_sublvl_collision(entering_sublvl)
		
func _set_sublvl_collision(enabled : bool):
	if enabled:
		$Background.material.shader = sublvl_shader
		$Background.material.set_shader_param("spriteDim", bg_dimen)
		$Background.material.set_shader_param("yOffset", $Background.offset.y)
		ball_in_sublvl = true
		ball.collision_layer = SUBLVL_LAYER
		ball.collision_mask = SUBLVL_MASK
	else:
		ball_in_sublvl = false
		$Background.material.shader = null
		ball.collision_layer = MAINLVL_LAYER
		ball.collision_mask = MAINLVL_MASK
