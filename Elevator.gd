extends Node2D


const CUBICLE_LIMIT_Y = -417
const INIT_Y = -24
const SPEED = 100.0
enum { IDLE, PRETRANSPORT, TRANSPORTING, POSTTRANSPORT }
var state : int

signal cubicle_reached

# Called when the node enters the scene tree for the first time.
func _ready():
	state = IDLE
	$Sprite.modulate.a = 0
	
	
func _process(delta):
	match state:
		PRETRANSPORT:
			$Sprite.modulate.a = ($TransitionTimer.wait_time - $TransitionTimer.time_left) / $TransitionTimer.wait_time
		TRANSPORTING:
			var new_pos_y = global_position.y - SPEED * delta
			if new_pos_y <= CUBICLE_LIMIT_Y:
				new_pos_y = CUBICLE_LIMIT_Y
				state = POSTTRANSPORT
				$TransitionTimer.start()
			global_position.y = new_pos_y
		POSTTRANSPORT:
			$Sprite.modulate.a = 1.0 - ($TransitionTimer.wait_time - $TransitionTimer.time_left) / $TransitionTimer.wait_time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func go_to_cubicle():
#	transporting = true
	state = PRETRANSPORT
	$TransitionTimer.start()
	
func go_to_lobby():
	global_position.y = INIT_Y


func _on_TransitionTimer_timeout():
	if state == PRETRANSPORT:
		$Sprite.modulate.a = 1.0
		state = TRANSPORTING
	else:
		emit_signal("cubicle_reached")
		$Sprite.modulate.a = 0.0
		state = IDLE
