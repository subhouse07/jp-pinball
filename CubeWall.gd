extends Node2D


var sprite_alpha = 1.0
var shape_lower_bound = 0
var shape_upper_bound = 0
var shape_height = 0
var in_transition = false
var ball : Node


func _ready():
	shape_height = $Area2D/CollisionShape2D.shape.extents.y * 2.0
	shape_lower_bound = $Area2D/CollisionShape2D.global_position.y + $Area2D/CollisionShape2D.shape.extents.y
	shape_upper_bound = $Area2D/CollisionShape2D.global_position.y - $Area2D/CollisionShape2D.shape.extents.y
	ball = get_parent().get_node("Ball")


func _process(delta):
	if in_transition:
		$Sprite.modulate.a = sprite_alpha


func _physics_process(delta):
	if in_transition and ball.position.y < shape_lower_bound and ball.position.y > shape_upper_bound:
		sprite_alpha = (ball.position.y - shape_upper_bound) / shape_height


func _on_Area2D_body_entered(body):
	if body.name == "Ball":
		in_transition = true


func _on_Area2D_body_exited(body):
	if body.name == "Ball":
		in_transition = false
