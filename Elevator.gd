extends Node2D

const SPRITE_INIT_Y = -12
const SPRITE_LIMIT_Y = -395
const SPRITE_OFFSET_INIT_Y = -190
const SPRITE_OFFSET_LIMIT_Y = -216
const CUBICLE_LIMIT_Y = -417
const INIT_Y = -24
const SPEED = 100.0
const OFFSET_SPEED = 7.0
enum { IDLE, PRETRANSPORT, TRANSPORTING, POSTTRANSPORT }
var state : int

signal cubicle_reached

# Called when the node enters the scene tree for the first time.
func _ready():
	state = IDLE
	$Sprite.modulate.a = 0
	$BgSprite.modulate.a = 0
	
	
func _process(delta):
	match state:
		PRETRANSPORT:
			$Sprite.modulate.a = ($TransitionTimer.wait_time - $TransitionTimer.time_left) / $TransitionTimer.wait_time
			$BgSprite.modulate.a = ($TransitionTimer.wait_time - $TransitionTimer.time_left) / $TransitionTimer.wait_time
		TRANSPORTING:
			var new_pos_y = $Sprite.position.y - SPEED * delta
			if new_pos_y <= SPRITE_LIMIT_Y:
				new_pos_y = SPRITE_LIMIT_Y
				state = POSTTRANSPORT
				$Sprite.stop()
				$TransitionTimer.start()
			var new_offset = $Sprite.offset.y - OFFSET_SPEED * delta
			if new_offset > SPRITE_OFFSET_LIMIT_Y:
				$Sprite.offset.y = new_offset
			$Sprite.position.y = new_pos_y
		POSTTRANSPORT:
			$Sprite.modulate.a = 1.0 - ($TransitionTimer.wait_time - $TransitionTimer.time_left) / $TransitionTimer.wait_time
			$BgSprite.modulate.a = 1.0 - ($TransitionTimer.wait_time - $TransitionTimer.time_left) / $TransitionTimer.wait_time
# Called every frame. 'delta' is the elapsed time since the previous frame.
func go_to_cubicle():
#	transporting = true
	state = PRETRANSPORT
	$TransitionTimer.start()
	
func go_to_lobby():
	$Sprite.position.y = SPRITE_INIT_Y
	$Sprite.offset.y = SPRITE_OFFSET_INIT_Y


func _on_TransitionTimer_timeout():
	if state == PRETRANSPORT:
		$Sprite.modulate.a = 1.0
		$BgSprite.modulate.a = 1.0
		$Sprite.play("default")
		state = TRANSPORTING
	else:
		emit_signal("cubicle_reached")
		$Sprite.modulate.a = 0.0
		$BgSprite.modulate.a = 0.0
		state = IDLE
