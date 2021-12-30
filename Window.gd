extends Node2D

var rotating = false
var open = false
var rotate_speed = 100.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.autostart = false


func _physics_process(delta):
	if rotating:
		if open:
			var new_rotation = rotation_degrees + rotate_speed * delta
			if new_rotation >= 0:
				rotation_degrees = 0
				rotating = false
				open = false
			else:
				rotation_degrees = new_rotation
		else:
			var new_rotation = rotation_degrees - rotate_speed * delta
			if new_rotation <= -45.0:
				rotation_degrees = -45.0
				rotating = false
				open = true
				$Timer.start()
			else:
				rotation_degrees = new_rotation


func _on_Timer_timeout():
	rotating = true


func _on_Area2D_body_exited(body):
	if body.name == "Ball":
		rotating = true
