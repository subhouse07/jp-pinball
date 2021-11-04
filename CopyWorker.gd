extends PathFollow2D

export var is_lift_worker : bool
export var unit_speed : float
export var index : int

var move_angle = 0
var is_active = false
var at_copier = false
var finished_copying = false
var queuing = false setget queuing_set, queueing_get

signal worker_hit(ind)
signal finished_copying(ind)

func _ready():
	set_active(false)


func _process(delta):
	if is_active and !at_copier and !queuing:
		var prev_pos = global_position
		if finished_copying:
			_move_to_home(delta)
		else:
			_move_to_copier(delta)
		_calculate_move_angle(prev_pos)


func _move_to_home(delta):
	var new_offset = unit_offset - unit_speed * delta
	if new_offset <= 0:
		unit_offset = 0
		set_active(false)
		emit_signal("finished_copying", index)
	else:
		unit_offset = new_offset


func _move_to_copier(delta):
	var new_offset = unit_offset + unit_speed * delta
	if new_offset >= 1.0:
		unit_offset = 1.0
		at_copier = true
		$WorkTimer.start()
	else:
		unit_offset = new_offset


func _calculate_move_angle(prev_pos):
	var new_angle = (prev_pos.angle_to_point(global_position) / 3.14)*180
	var angle_diff = new_angle - move_angle
	
	if abs(angle_diff) > 0.05:
		if new_angle <= 22.5 and new_angle > -22.5:
			_set_animation("side", true)
		elif new_angle <= 67.5 and new_angle > 22.5:
			_set_animation("diag_back", false)
		elif new_angle <= 112.5 and new_angle > 67.5:
			_set_animation("back", false)
		elif new_angle <= 157.5 and new_angle > 112.5:
			_set_animation("diag_back", true)
		elif new_angle > 157.5 or new_angle < - 157.5:
			_set_animation("side", false)
		elif new_angle >= -157.5 and new_angle < -112.5:
			_set_animation("diag_fore", false)
		elif new_angle >= -112.5 and new_angle < -67.5:
			_set_animation("fore", false)
		elif new_angle >= -67.5 and new_angle < -22.5:
			_set_animation("diag_fore", true)
		
	move_angle = new_angle


func _set_animation(name, is_flipped):
	if $AnimatedSprite.animation != name:
		$AnimatedSprite.animation = name
		$AnimatedSprite.flip_h = is_flipped
	elif $AnimatedSprite.flip_h != is_flipped:
		$AnimatedSprite.flip_h = is_flipped


func _set_collisions(enabled: bool):
	if enabled:
		$SpriteArea.collision_layer = 1
		$SpriteArea.collision_mask = 1
	else:
		$SpriteArea.collision_layer = 0
		$SpriteArea.collision_mask = 0


func _on_SpriteArea_body_entered(body):
	if body.name == "Ball":
		if is_lift_worker:
			emit_signal("worker_hit", index)
			if at_copier:
				emit_signal("finished_copying", index)
		set_active(false)


func set_active(active : bool):
	finished_copying = false
	at_copier = false
	is_active = active
	visible = active
	_set_collisions(active)
	if !active:
		offset = 0


func _on_WorkTimer_timeout():
	finished_copying = true
	at_copier = false


func queuing_set(is_queuing : bool):
	queuing = is_queuing


func queueing_get():
	return queuing
