extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(int) var rotation_speed
export(bool) var is_flipped
var max_rotation
var init_rotation

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_flipped:
		max_rotation = -20
		init_rotation = 15
		$RightArea.queue_free()
		$RightSprite.queue_free()
	else:
		max_rotation = 20
		init_rotation = -15
		$LeftArea.queue_free()
		$LeftSprite.queue_free()
		
	rotation_degrees = init_rotation

func _physics_process(delta):
	
	if is_flipped and Input.is_action_pressed("ui_left"):
		flip_left(delta)
	elif !is_flipped and Input.is_action_pressed("ui_right"):
		flip_right(delta)
	elif rotation_degrees != init_rotation:
		if is_flipped:
			retract_left(delta)
		else:
			retract_right(delta)
	
func flip_left(delta):
	var new_degrees = rotation_degrees - rotation_speed * delta
	if new_degrees < max_rotation:
		new_degrees = max_rotation
	rotation_degrees = new_degrees
	
func flip_right(delta):
	var new_degrees = rotation_degrees + rotation_speed * delta
	if new_degrees > max_rotation:
		new_degrees = max_rotation
	rotation_degrees = new_degrees
	
func retract_left(delta):
	var new_degrees = rotation_degrees + rotation_speed * delta
	if new_degrees > init_rotation:
		new_degrees = init_rotation
	rotation_degrees = new_degrees
	
func retract_right(delta):
	var new_degrees = rotation_degrees - rotation_speed * delta
	if new_degrees < init_rotation:
		new_degrees = init_rotation
	rotation_degrees = new_degrees
