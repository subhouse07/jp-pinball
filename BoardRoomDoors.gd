extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func reset():
	$"/root/GameState".reset_boardroom_doors()


func _on_Area2D_body_entered(body):
	if body.name == "Ball":
		$"/root/GameState".hit_boardroom_doors()
		if $"/root/GameState".hp_boardroom_doors <= 0:
			# Replace with door animation or whatever
			_disable_collision()

func _disable_collision():
	$StaticBody2D.collision_layer = 0
	$StaticBody2D.collision_mask = 0
	$Area2D.collision_layer = 0
	$Area2D.collision_mask = 0
	$Sprite.hide()
