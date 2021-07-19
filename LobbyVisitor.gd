extends PathFollow2D

const UNIT_SPEED = 0.038
const COLLISION_MASK_ENABLE = 1
const COLLISION_LAYER_ENABLE = 1
const COLLISION_MASK_DISABLE = 0
const COLLISION_LAYER_DISABLE = 0

var visiting = false
var waiting = false
var worker_hit = false
var resetting = false
var move_angle = 0
export var index: int

signal visitor_hit(index)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if !resetting and !visiting and !waiting:
		var prev_pos = global_position
		_move_visitor(delta)
		_calculate_move_angle(prev_pos)
	
func _move_visitor(delta):
	
	var new_offset = unit_offset + UNIT_SPEED * delta
	if new_offset > 1.0:
		unit_offset = 0
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

func _set_animation(name, is_flipped):
	if $AnimatedSprite.animation != name:
		$AnimatedSprite.animation = name
		$AnimatedSprite.flip_h = is_flipped
	elif $AnimatedSprite.flip_h != is_flipped:
		$AnimatedSprite.flip_h = is_flipped

func reset():
	visiting = false
	waiting = false
	worker_hit = false
	unit_offset = 0
	$AnimatedSprite.hide()
	resetting = true
	$ResetTimer.start()


func _on_VisitorArea_body_entered(body):
	if body.name == "Ball":
		print("visitor entered")
	if body.name == "Ball" and !waiting and !visiting:
		emit_signal("visitor_hit", index)
		$CollisionTimer.start()
		

func _on_ResetTimer_timeout():
	resetting = false
	$AnimatedSprite.show()


func _on_CollisionTimer_timeout():
	reset()
	
func enable_collision():
	$StaticBody2D.collision_mask = 1
	$StaticBody2D.collision_layer = 1
	
func disable_collision():
	$StaticBody2D.collision_mask = 0
	$StaticBody2D.collision_layer = 0
	
	
