extends Node2D


var trapped = false
var trapped_position := Vector2()

signal success
signal failure


func _on_TrapDoor_ball_trapped():
	$Ball.hide()
	$Ball.mode = RigidBody2D.MODE_KINEMATIC
	trapped = true
	trapped_position = $Ball.global_position


func _on_TrapDoor_door_timed_out(x, y):
	emit_signal("success")


func _on_Area2D_body_entered(body):
	if body.name == "Ball":
		emit_signal("failure")
