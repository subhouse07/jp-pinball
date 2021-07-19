extends PathFollow2D

const BASE_WORK_TIME = 20.0
const COLLISION_MASK_ENABLE = 1
const COLLISION_LAYER_ENABLE = 1
const COLLISION_MASK_DISABLE = 0
const COLLISION_LAYER_DISABLE = 0

var with_visitor = false
var waiting_for_visitor = false
var at_desk = true
var resetting = false
var move_angle = 0
export var index: int
export var unit_speed: float

signal desk_reached(index)
signal worker_hit(index)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var prev_pos = global_position
	
	if !resetting:
		if !at_desk:
			if with_visitor:
				_move_to_desk(delta)
			else:
				_move_to_meeting(delta)
		
		_calculate_move_angle(prev_pos)

func _move_to_desk(delta):
	var new_offset = unit_offset - unit_speed * delta
	if new_offset <= 0:
		unit_offset = 0
		at_desk = true
		$StaticBody2D.collision_mask = COLLISION_MASK_DISABLE
		$StaticBody2D.collision_layer = COLLISION_LAYER_DISABLE
		emit_signal("desk_reached", index)
	else:
		unit_offset = new_offset
	
func _move_to_meeting(delta):
	var new_offset = unit_offset + unit_speed * delta
	if new_offset > 1.0:
		unit_offset = 1.0
	else:
		unit_offset = new_offset

func _calculate_move_angle(prev_pos):
	var new_angle = (prev_pos.angle_to_point(global_position) / 3.14)*180
	var angle_diff = new_angle - move_angle
	
	if abs(angle_diff) > 0.05:
		if new_angle <= 22.5 and new_angle > -22.5:
			_set_animation("side", true)
		elif new_angle <= 67.5 and new_angle > 22.5:
#			print("diag_back, flipped")
			_set_animation("diag_back", false)
		elif new_angle <= 112.5 and new_angle > 67.5:
			_set_animation("back", false)
		elif new_angle <= 157.5 and new_angle > 112.5:
#			print("diag_back, unflipped")
			_set_animation("diag_back", true)
		elif new_angle > 157.5 or new_angle < - 157.5:
			_set_animation("side", false)
		elif new_angle >= -157.5 and new_angle < -112.5:
#			print("diag_fore, unflipped")
			_set_animation("diag_fore", false)
		elif new_angle >= -112.5 and new_angle < -67.5:
			_set_animation("fore", false)
		elif new_angle >= -67.5 and new_angle < -22.5:
#			print("diag_fore, flipped")
			_set_animation("diag_fore", true)
		
	move_angle = new_angle
	
func _on_WorkTimer_timeout():
	at_desk = false
	$StaticBody2D.collision_mask = COLLISION_MASK_ENABLE
	$StaticBody2D.collision_layer = COLLISION_LAYER_ENABLE
	$WorkTimer.wait_time = BASE_WORK_TIME
	
func reset():
	$WorkTimer.stop()
	with_visitor = false
	waiting_for_visitor = false
	at_desk = true
	unit_offset = 0
	$AnimatedSprite.hide()
	resetting = true
	$ResetTimer.start()


func _on_WorkerArea_body_entered(body):
	if body.name == "Ball":
		print("worker entered")
	if body.name == "Ball" and !at_desk:
#		print("worker hit")
		emit_signal("worker_hit", index)
		$CollisionTimer.start()
		

func _on_ResetTimer_timeout():
	resetting = false
	$AnimatedSprite.show()
	$WorkTimer.start()


func _on_CollisionTimer_timeout():
	reset()
	
func _set_animation(name, is_flipped):
	if $AnimatedSprite.animation != name:
		$AnimatedSprite.animation = name
		$AnimatedSprite.flip_h = is_flipped
	elif $AnimatedSprite.flip_h != is_flipped:
		$AnimatedSprite.flip_h = is_flipped
