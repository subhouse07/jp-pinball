extends Node2D


export(bool) var is_teleport
export(float) var my_time
export(float) var launch_x
export(float) var launch_y

var is_trapping = false
var timer
var sprite

signal ball_trapped
signal door_timed_out(x, y)


func _ready():
	_add_timer()
	sprite = get_node_or_null("Sprite")
	

func _add_timer():
	timer = Timer.new()
	timer.wait_time = my_time
	timer.one_shot = true
	timer.connect("timeout", self, "_on_Timer_timeout")
	add_child(timer)


func _on_Area2D_body_entered(body):
	if body.name == "Ball" and !is_trapping:
		is_trapping = true
		if sprite:
			sprite.play()
		emit_signal("ball_trapped")
		if !is_teleport:
			timer.start()


func _on_AnimatedSprite_animation_finished():
	sprite.stop()
	if is_teleport and is_trapping:
		is_trapping = false
		sprite.play("default", true)


func _on_Timer_timeout():
	is_trapping = false
	emit_signal("door_timed_out", launch_x, launch_y)
