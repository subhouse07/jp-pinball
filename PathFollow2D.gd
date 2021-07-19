extends PathFollow2D

var move_angle = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _process(delta):
	var prev_pos = global_position
	unit_offset = unit_offset + 0.085 * delta
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
	if $AnimatedSprite3.animation != name:
		$AnimatedSprite3.animation = name
		$AnimatedSprite3.flip_h = is_flipped
	elif $AnimatedSprite3.flip_h != is_flipped:
		$AnimatedSprite3.flip_h = is_flipped
