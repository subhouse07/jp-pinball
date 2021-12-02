extends Node2D

var move_angle : float = 0
var remote_node : Node

func _ready():
	remote_node = get_node(self.remote_path)


func calculate_move_angle(prev_pos):
	var new_angle = (prev_pos.angle_to_point(global_position) / 3.14)*180
	var angle_diff = new_angle - move_angle
	
	if abs(angle_diff) > 0.05:
		if new_angle <= 22.5 and new_angle > -22.5:
			_set_animation("side", true)
		elif new_angle <= 67.5 and new_angle > 22.5:
			_set_animation("diag_back", false)
		elif new_angle <= 112.5 and new_angle > 67.5:
			_set_animation("back", false)
		elif new_angle <= 157.5 and new_angle > 112.5:
			_set_animation("diag_back", true)
		elif new_angle > 157.5 or new_angle < - 157.5:
			_set_animation("side", false)
		elif new_angle >= -157.5 and new_angle < -112.5:
			_set_animation("diag_fore", false)
		elif new_angle >= -112.5 and new_angle < -67.5:
			_set_animation("fore", false)
		elif new_angle >= -67.5 and new_angle < -22.5:
			_set_animation("diag_fore", true)
		
	move_angle = new_angle


func _set_animation(name, is_flipped):
	if remote_node.animation != name:
		remote_node.animation = name
		remote_node.flip_h = is_flipped
	elif remote_node.flip_h != is_flipped:
		remote_node.flip_h = is_flipped
