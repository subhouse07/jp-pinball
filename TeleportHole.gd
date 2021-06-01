extends Node2D


export var points := [Vector2(), Vector2()]

signal teleport_entered(coords)
var teleporting = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Hole_body_entered(body, to_index):
	if !teleporting:
		teleporting = true
		emit_signal("teleport_entered", points[to_index])
		$Timer.start()




func _on_Timer_timeout():
	teleporting = false
