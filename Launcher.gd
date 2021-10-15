extends Node2D

enum { PRE_LOADING, LOADING, LAUNCHING, DISEMBARKED, POST_DISEMBARK, EXITING }

const PRELAUNCH_STOP_OFFSET = 743
const EARLY_DISEMBARK_ALLOW_OFFSET = 1050
const DISEMBARK_STOP_OFFSET = 1945
const EXITING_STOP_OFFSET = 2170
const SIDE_SPRITE_XOFFSET = -23
const SIDE_SPRITE_YOFFSET = -19
const TOP_SPRITE_XOFFSET = 0
const TOP_SPRITE_YOFFSET = 58

export(int) var max_speed
export(int) var acceleration
export(int) var prelaunch_speed

var launch_status
var launch_speed
var accel_factor
var early_disembark = false
var launching = false
var disembarked = false
var side_train_res : Resource
var top_train_res : Resource
var train_sprite : Sprite
var path_follow : PathFollow2D

signal ball_disembarked(coords, early_disembark)
signal ball_captured


func _ready():
	train_sprite = $Path2D/PathFollow2D/Sprite
	path_follow = $Path2D/PathFollow2D
	
	side_train_res = preload("res://train-side.png")
	top_train_res = preload("res://train-top.png")
	_modify_train_sprite(true)
	
	launch_status = PRE_LOADING
	launch_speed = 0
	accel_factor = 0


func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if launch_status == LOADING:
			launch_status = LAUNCHING
			$LaunchTimer.start()
		elif launch_status == LAUNCHING and path_follow.offset >= EARLY_DISEMBARK_ALLOW_OFFSET:
			early_disembark = true
			launch_status = DISEMBARKED
			
	if launch_status == DISEMBARKED:
		accel_factor = 0
		emit_signal("ball_disembarked", path_follow.global_position, early_disembark)
		early_disembark = false
		if path_follow.offset < DISEMBARK_STOP_OFFSET:
			launch_status = EXITING
		else:
			launch_status = POST_DISEMBARK
			$ResetTimer.start()	


func _physics_process(delta):
	match launch_status:
		PRE_LOADING:
			if path_follow.offset != 0:
				path_follow.offset = 0
				launch_speed = 0
			if train_sprite.texture != side_train_res:
				_modify_train_sprite(true)
		LAUNCHING:
			if path_follow.offset >= DISEMBARK_STOP_OFFSET:
				launch_status = DISEMBARKED
				launch_speed = 0
			else:
				if launch_speed < max_speed:
					var elapsed = $LaunchTimer.wait_time - $LaunchTimer.time_left
					var pct = elapsed / $LaunchTimer.wait_time
					accel_factor += acceleration
					launch_speed = accel_factor + pow(pct, 3.0) * max_speed
				path_follow.offset = path_follow.offset + launch_speed * delta
		EXITING:
			if path_follow.offset >= EXITING_STOP_OFFSET:
				launch_status = PRE_LOADING
			else:
				if launch_speed < max_speed:
					launch_speed += acceleration
				path_follow.offset = path_follow.offset + launch_speed * delta


func _on_CaptureArea_body_entered(body):
	if body.name == "Ball":
		launch_status = LOADING
		emit_signal("ball_captured")


func _on_ResetTimer_timeout():
	launch_status = EXITING


func _on_SpriteChangeArea_area_entered(area):
	if area.name == "CaptureArea":
		_modify_train_sprite(false)

func _modify_train_sprite(is_side_view : bool):
	if is_side_view:
		train_sprite.texture = side_train_res
		train_sprite.offset.x = SIDE_SPRITE_XOFFSET
		train_sprite.offset.y = SIDE_SPRITE_YOFFSET
		z_index = 0
	else:
		train_sprite.texture = top_train_res
		train_sprite.offset.x = TOP_SPRITE_XOFFSET
		train_sprite.offset.y = TOP_SPRITE_YOFFSET
		z_index -= 1
