extends Node2D

enum { DISABLED, ENABLED }
var active_target = 0
var targets : Node
var target_count : int
var targets_hit = []

signal file_target_hit

func _ready():
	targets = $Targets
	target_count = targets.get_child_count()
	for i in target_count:
		targets_hit.append(false)
		_set_target_active(targets.get_child(i), DISABLED)


func activate_task():
	randomize()
	active_target = randi() % target_count
	_set_target_active(targets.get_child(active_target), ENABLED)


func _on_TargetArea_body_entered(body, ind):
	if body.name == "Ball" && !targets_hit[ind]:
		targets_hit[ind] = true
		_set_target_active(targets.get_child(ind), DISABLED)
		var incomplete = false
		for i in target_count:
			if !targets_hit[i]:
				incomplete = true
		if incomplete:
			while targets_hit[active_target] == true:
				active_target = randi() % target_count
			_set_target_active(targets.get_child(active_target), ENABLED)
		emit_signal("file_target_hit")


func _set_target_active(target: Node, val: int):
	target.get_child(0).collision_layer = val
	target.get_child(0).collision_mask = val
	target.get_child(1).collision_mask = val
	target.get_child(1).collision_layer = val
	if val == DISABLED:
		target.hide()
	else:
		target.show()


func reset():
	for i in target_count:
		_set_target_active(targets.get_child(i), DISABLED)
		targets_hit[i] = false
