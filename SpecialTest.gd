extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var trapped = false
var trapped_position := Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TrapDoor_ball_trapped():
	$Ball.hide()
	$Ball.mode = RigidBody2D.MODE_KINEMATIC
	trapped = true
	trapped_position = $Ball.global_position
	
	
func _on_TrapDoor_door_timed_out(x, y):
	get_parent().load_scene("MainBoard")
