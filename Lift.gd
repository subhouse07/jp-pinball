extends Node2D

enum { DISABLED, ENABLED }
var activated = false setget activated_set, activated_get
var transitioning = false

signal lift_hit

# Called when the node enters the scene tree for the first time.
func _ready():
	deactivate()


func activate():
	show()
	_set_collisions(ENABLED)
	activated = true


func deactivate():
	hide()
	_set_collisions(DISABLED)
	activated = false

func _set_collisions(val : int):
	$StaticBody2D.collision_layer = val
	$StaticBody2D.collision_mask = val
	$LiftArea.collision_layer = val
	$LiftArea.collision_mask = val

func _on_LiftArea_body_entered(body):
	if body.name == "Ball" and !transitioning:
		emit_signal("lift_hit")
		# play animation
		$AnimationTimer.start()
		transitioning = true

func activated_set(new_val):
	activated = new_val

func activated_get():
	return activated


func _on_AnimationTimer_timeout():
	transitioning = false
	deactivate()
