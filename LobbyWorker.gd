extends PathFollow2D

const BASE_WORK_TIME = 20.0
const COLLISION_MASK_ENABLE = 1
const COLLISION_LAYER_ENABLE = 1
const COLLISION_MASK_DISABLE = 0
const COLLISION_LAYER_DISABLE = 0

var with_visitor = false
var waiting_for_visitor = false
var at_desk = true
var resetting = false
var move_angle = 0
export var index: int
export var unit_speed: float

signal desk_reached(index)
signal worker_hit(index)


func _process(delta):
	var prev_pos = global_position
	if !resetting:
		if !at_desk:
			if with_visitor:
				_move_to_desk(delta)
			else:
				_move_to_meeting(delta)
		$WalkerRemoteTransform.calculate_move_angle(prev_pos)


func _move_to_desk(delta):
	var new_offset = unit_offset - unit_speed * delta
	if new_offset <= 0:
		unit_offset = 0
		at_desk = true
		$StaticBody2D.collision_mask = COLLISION_MASK_DISABLE
		$StaticBody2D.collision_layer = COLLISION_LAYER_DISABLE
		emit_signal("desk_reached", index)
	else:
		unit_offset = new_offset


func _move_to_meeting(delta):
	var new_offset = unit_offset + unit_speed * delta
	if new_offset > 1.0:
		unit_offset = 1.0
	else:
		unit_offset = new_offset


func _on_WorkTimer_timeout():
	at_desk = false
	$StaticBody2D.collision_mask = COLLISION_MASK_ENABLE
	$StaticBody2D.collision_layer = COLLISION_LAYER_ENABLE
	$WorkTimer.wait_time = BASE_WORK_TIME


func reset():
	$WorkTimer.stop()
	with_visitor = false
	waiting_for_visitor = false
	at_desk = true
	unit_offset = 0
	$WalkerRemoteTransform.set_sprite_visible(false)
	resetting = true
	$ResetTimer.start()


func _on_WorkerArea_body_entered(body):
	if body.name == "Ball" and !at_desk:
		emit_signal("worker_hit", index)
		$CollisionTimer.start()


func _on_ResetTimer_timeout():
	resetting = false
	$WalkerRemoteTransform.set_sprite_visible(true)
	$WorkTimer.start()


func _on_CollisionTimer_timeout():
	reset()
