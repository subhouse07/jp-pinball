extends Node2D

const SLOWDOWN_FACTOR = 7.0

var ball_captured = false
var capture_index : int
var capture_coords := Vector2()
var active_path = 0
var courier_count : int

signal ball_captured
signal ball_released
signal special_triggered


func _ready():
	courier_count = $CourierPaths/Path2D.get_child_count()


func _physics_process(delta):
	if ball_captured:
		capture_coords = $CourierPaths.get_child(active_path).get_child(capture_index).global_position


func _on_Courier_captured_ball(index):
	var couriers = $CourierPaths.get_child(active_path).get_children()
	for c in couriers:
		c.disable_collision()
	if active_path < 2:
		capture_index = index
		ball_captured = true
		capture_coords = couriers[index].global_position
		emit_signal("ball_captured")
	else:
		emit_signal("special_triggered")
		go_to_next_path()


func _on_Courier_hit(index):
	courier_count -= 1
	if courier_count <= 0:
		courier_count = $CourierPaths.get_child(active_path).get_child_count()
		go_to_next_path()
	elif courier_count == 1:
		$CourierPaths.get_child(active_path).get_child(0).set_as_final()


func _on_ReleaseArea_area_entered(area):
	if ball_captured and area.get_parent().index == capture_index:
		ball_captured = false
		var couriers = $CourierPaths.get_child(active_path).get_children()
		for c in couriers:
			if !c.disabled and !c.is_lead:
				c.enable_collision()
		emit_signal("ball_released")


func _reparent_couriers():
	var old_index
	if active_path == 0:
		old_index = 2
	else:
		old_index = active_path - 1
		
	var old_path = $CourierPaths.get_child(old_index)
	var new_path = $CourierPaths.get_child(active_path)
	var couriers = old_path.get_children()
	
	for i in couriers.size():
		old_path.remove_child(couriers[i])
		new_path.add_child(couriers[i])
		if active_path < 2 or i == 0:
			couriers[i].reset()


func _on_SlowdownArea_area_entered(area):
	if area.name == "CourierArea":
		var node = area.get_parent()
		node.hide()
		node.unit_speed /= SLOWDOWN_FACTOR
		if !node.disabled:
			node.in_slow_zone = true
			node.disable_collision()


func _on_SlowdownArea_area_exited(area):
	if area.name == "CourierArea":
		var node = area.get_parent()
		node.show()
		node.unit_speed *= SLOWDOWN_FACTOR
		if !node.disabled:
			node.in_slow_zone = false
			node.enable_collision()


func go_to_next_path():
	if active_path < 2:
		active_path += 1
	else:
		active_path = 0
	_reparent_couriers()


func reset():
	active_path = 0
	_reparent_couriers()
