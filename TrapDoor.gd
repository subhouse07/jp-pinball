extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(bool) var is_teleport
export(float) var my_time
export(float) var launch_x
export(float) var launch_y

var is_trapping = false
var timer

signal ball_trapped
signal door_timed_out(x, y)

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = Timer.new()
	timer.wait_time = my_time
	timer.one_shot = true
	timer.connect("timeout", self, "_on_Timer_timeout")
	add_child(timer)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if body.name == "Ball" and !is_trapping:
		is_trapping = true
		$AnimatedSprite.play()
		emit_signal("ball_trapped")
		if !is_teleport:
			timer.start()


func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.stop()
	if is_teleport and is_trapping:
		is_trapping = false
		$AnimatedSprite.play("default", true)
		

func _on_Timer_timeout():
	is_trapping = false
	$AnimatedSprite.play("default", true)
	emit_signal("door_timed_out", launch_x, launch_y)
