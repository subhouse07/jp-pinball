extends Node2D

enum { IDLE, PRETRANSPORT, TRANSPORTING, POSTTRANSPORT }

const INIT_Y = -12
const LIMIT_Y = -395
const OFFSET_INIT_Y = -190
const OFFSET_LIMIT_Y = -216
const ELEV_SPEED = 100.0
const OFFSET_SPEED = 7.0

var state : int

signal cubicle_reached


func _ready():
	state = IDLE
	$ElevSprite.modulate.a = 0
	$BgSprite.modulate.a = 0


func _process(delta):
	match state:
		PRETRANSPORT:
			$ElevSprite.modulate.a = _percent_time_left()
			$BgSprite.modulate.a = _percent_time_left()
		TRANSPORTING:
			_move_elevator_sprite(delta)
			_adjust_offset(delta)
		POSTTRANSPORT:
			$ElevSprite.modulate.a = 1.0 - _percent_time_left()
			$BgSprite.modulate.a = 1.0 - _percent_time_left()


func go_to_cubicle():
	state = PRETRANSPORT
	$TransitionTimer.start()


func go_to_lobby():
	$ElevSprite.position.y = INIT_Y
	$ElevSprite.offset.y = OFFSET_INIT_Y


func _move_elevator_sprite(delta):
	var new_pos_y = $ElevSprite.position.y - ELEV_SPEED * delta
	if new_pos_y <= LIMIT_Y:
		new_pos_y = LIMIT_Y
		$ElevSprite.stop()
		state = POSTTRANSPORT
		$TransitionTimer.start()
	$ElevSprite.position.y = new_pos_y


func _adjust_offset(delta):
	var new_offset = $ElevSprite.offset.y - OFFSET_SPEED * delta
	if new_offset > OFFSET_LIMIT_Y:
		$ElevSprite.offset.y = new_offset


func _percent_time_left():
	var elapsed = $TransitionTimer.wait_time - $TransitionTimer.time_left
	return elapsed / $TransitionTimer.wait_time


func _on_TransitionTimer_timeout():
	if state == PRETRANSPORT:
		$ElevSprite.modulate.a = 1.0
		$BgSprite.modulate.a = 1.0
		$ElevSprite.play("default")
		state = TRANSPORTING
	else:
		emit_signal("cubicle_reached")
		$ElevSprite.modulate.a = 0.0
		$BgSprite.modulate.a = 0.0
		state = IDLE
