extends Node2D


func _ready():
	pass # Replace with function body.


func _on_Area2D_body_entered(body):
	if body.name == "Ball":
		$"/root/GameState".hit_boardroom_doors()
		if $"/root/GameState".hp_state["boardroom_doors"] <= 0:
			# Replace with door animation or whatever
			$Sprite.hide()
			_disable_collision()


func _disable_collision():
	$StaticBody2D.collision_layer = 0
	$StaticBody2D.collision_mask = 0
	$Area2D.collision_layer = 0
	$Area2D.collision_mask = 0


func _enable_collision():
	$StaticBody2D.collision_layer = 1
	$StaticBody2D.collision_mask = 1
	$Area2D.collision_layer = 1
	$Area2D.collision_mask = 1


func reset():
	$"/root/GameState".reset_boardroom_doors()
	$Sprite.show()
	_enable_collision()
