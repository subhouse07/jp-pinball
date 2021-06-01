extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var value = 250

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body, positive):
	
	
	if body.name == "Ball":
		print("linear velocity: " + String($Ball.linear_velocity))
		if positive:
#			print("left bump reflect: " + String(Vector2(1, -1).bounce($Ball.linear_velocity)))
			$Ball.apply_central_impulse(2*$Ball.linear_velocity.bounce(Vector2(1, -1)) + Vector2(value, -value))
			
		else:
#			print("right bump reflect: ")
#			print($Ball.linear_velocity.bounce(position.normalized()))
			$Ball.apply_central_impulse(2*$Ball.linear_velocity.bounce(Vector2(-1, -1)) + Vector2(-value, -value))
			
