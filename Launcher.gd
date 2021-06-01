extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const PRE_LOADING = -1
const LOADING = 0
const PRE_LAUNCH = 1
const LAUNCHING = 2
const DISEMBARKED = 3
const POST_DISEMBARK = 4
const EXITING = 5
const PRELAUNCH_STOP_OFFSET = 280
const DISEMBARK_STOP_OFFSET = 1210
const EXITING_STOP_OFFSET = 1375

var launch_speed
export(int) var max_speed
export(int) var acceleration
export(int) var prelaunch_speed
var early_disembark = false
var launching
var disembarked
var launch_status

signal ball_disembarked(coords, early_disembark)
signal ball_captured

# Called when the node enters the scene tree for the first time.
func _ready():
	launch_status = PRE_LOADING
	launch_speed = 0
	launching = false
	disembarked = false


func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if launch_status == PRE_LAUNCH:
			launch_status = LAUNCHING
		elif launch_status == LAUNCHING:
			early_disembark = true
			launch_status = DISEMBARKED
			
	if launch_status == DISEMBARKED:
#		$Path2D/PathFollow2D/Camera2D.current = false
		emit_signal("ball_disembarked", $Path2D/PathFollow2D.global_position, early_disembark)
		early_disembark = false
		if $Path2D/PathFollow2D.offset < DISEMBARK_STOP_OFFSET:
			launch_status = EXITING
		else:
			launch_status = POST_DISEMBARK
			$ResetTimer.start()	
	
		
#		if !launching:
#			launching = true
#			# start doing path stuff
#		elif !disembarked:
#			emit_signal("ball_disembarked")
	
		
			
			

func _physics_process(delta):
	match launch_status:
		PRE_LOADING:
			if $Path2D/PathFollow2D.offset != 0:
				$Path2D/PathFollow2D.offset = 0
				launch_speed = 0
		LOADING:
			$Path2D/PathFollow2D.offset = $Path2D/PathFollow2D.offset + prelaunch_speed * delta
			if $Path2D/PathFollow2D.offset >= PRELAUNCH_STOP_OFFSET:
				launch_status = PRE_LAUNCH
		LAUNCHING:
			if $Path2D/PathFollow2D.offset >= DISEMBARK_STOP_OFFSET:
				launch_status = DISEMBARKED
				launch_speed = 0
			else:
				if launch_speed < max_speed:
					launch_speed += acceleration
				$Path2D/PathFollow2D.offset = $Path2D/PathFollow2D.offset + launch_speed * delta
		EXITING:
			if $Path2D/PathFollow2D.offset >= EXITING_STOP_OFFSET:
				launch_status = PRE_LOADING
			else:
				if launch_speed < max_speed:
					launch_speed += acceleration
				$Path2D/PathFollow2D.offset = $Path2D/PathFollow2D.offset + launch_speed * delta
			
#	if launching:
#		$Path2D/PathFollow2D.offset = $Path2D/PathFollow2D.offset + launch_speed * delta
#		if $Path2D/PathFollow2D.offset >= 1200 and !disembarked:
#			print("emitting signal")
#			emit_signal("ball_disembarked")
#			print("setting disembarked to true")
#			disembarked = true
			
		
		

func _on_Area2D_body_entered(body):
	if body.name == "Ball":
		launch_status = LOADING
		emit_signal("ball_captured")
#		$Path2D/PathFollow2D/Camera2D.current = true


func _on_ResetTimer_timeout():
	print("timed out")
	launch_status = EXITING
