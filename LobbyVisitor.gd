extends PathFollow2D

const UNIT_SPEED = 0.038
const COLLISION_MASK_ENABLE = 1
const COLLISION_LAYER_ENABLE = 1
const COLLISION_MASK_DISABLE = 0
const COLLISION_LAYER_DISABLE = 0

var visiting = false
var waiting = false
var worker_hit = false
var resetting = false
export var index: int

signal visitor_hit(index)


func _process(delta):
	if !resetting and !visiting and !waiting:
		var prev_pos = global_position
		_move_visitor(delta)
		$WalkerRemoteTransform.calculate_move_angle(prev_pos)


func _move_visitor(delta):
	var new_offset = unit_offset + UNIT_SPEED * delta
	if new_offset > 1.0:
		unit_offset = 0
	else:
		unit_offset = new_offset


func reset():
	visiting = false
	waiting = false
	worker_hit = false
	unit_offset = 0
	$WalkerRemoteTransform.set_sprite_visible(false)
	resetting = true
	$ResetTimer.start()


func _on_VisitorArea_body_entered(body):
	if body.name == "Ball" and !waiting and !visiting:
		emit_signal("visitor_hit", index)
		$CollisionTimer.start()


func _on_ResetTimer_timeout():
	resetting = false
	$WalkerRemoteTransform.set_sprite_visible(true)


func _on_CollisionTimer_timeout():
	reset()


func enable_collision():
	$StaticBody2D.collision_mask = 1
	$StaticBody2D.collision_layer = 1


func disable_collision():
	$StaticBody2D.collision_mask = 0
	$StaticBody2D.collision_layer = 0
