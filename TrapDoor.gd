extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(bool) var is_teleport

var is_trapping = false

signal ball_trapped
signal door_timed_out

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if body.name == "Ball" and !is_trapping:
		is_trapping = true
		$AnimatedSprite.play()
		emit_signal("ball_trapped")
		if !is_teleport:
			$Timer.start()


func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.stop()
	if is_teleport and is_trapping:
		is_trapping = false
		$AnimatedSprite.play("default", true)
		

func _on_Timer_timeout():
	is_trapping = false
	$AnimatedSprite.play("default", true)
	emit_signal("door_timed_out")
