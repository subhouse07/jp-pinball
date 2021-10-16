extends Node2D

enum { DISABLED, ENABLED }
var active_target = 0
var target_count : int

func _ready():
	target_count = $Targets.get_child_count()
	for i in $Targets.get_child_count():
		if i > 0:
			_set_target_active($Targets.get_child(i), DISABLED)



func _on_TargetArea_body_entered(body, ind):
	if body.name == "Ball":
		_set_target_active($Targets.get_child(ind), DISABLED)
		active_target += 1
		if active_target >= target_count:
			active_target = 0
		_set_target_active($Targets.get_child(active_target), ENABLED)
		


func _set_target_active(target: Node, val: int):
	target.get_child(0).collision_layer = val
	target.get_child(0).collision_mask = val
	target.get_child(1).collision_mask = val
	target.get_child(1).collision_layer = val
	if val == DISABLED:
		target.hide()
	else:
		target.show()
