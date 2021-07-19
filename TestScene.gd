extends Node2D

var courier_captured = false

func _physics_process(delta):
	if courier_captured:
		$Ball.global_position = $CourierCoordinator.capture_coords

func _on_CourierCoordinator_ball_captured():
	$Ball.global_position
	$Ball.mode = RigidBody2D.MODE_KINEMATIC
	courier_captured = true

func _on_CourierCoordinator_ball_released():
	courier_captured = false
	$Ball.global_position = $CourierCoordinator.capture_coords
	$Ball.linear_velocity = Vector2(0,0)
	$Ball.angular_velocity = 0
	$Ball.mode = RigidBody2D.MODE_CHARACTER
