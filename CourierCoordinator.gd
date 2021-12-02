extends Node2D

const SLOWDOWN_FACTOR = 7.0
const FINAL_PATH_INDEX = 2

var ball_captured = false
var capture_index : int
var capture_coords := Vector2()
var active_path = 0
var courier_count : int
var paths : Node

signal ball_captured
signal ball_released
signal special_triggered


func _ready():
	paths = $CourierPaths
	courier_count = paths.get_node("Path2D").get_child_count()


func _physics_process(delta):
	if ball_captured:
		capture_coords = paths.get_child(active_path).get_child(capture_index).global_position


func _on_Courier_captured_ball(index):
	var couriers = paths.get_child(active_path).get_children()
	for c in couriers:
		c.disable_collision()
	capture_index = index
	ball_captured = true
	capture_coords = couriers[index].global_position
	emit_signal("ball_captured")


func _on_Courier_hit():
	courier_count -= 1
	if courier_count <= 0 or active_path == FINAL_PATH_INDEX:
		courier_count = paths.get_child(active_path).get_child_count()
		if active_path == 2:
			emit_signal("special_triggered")
		go_to_next_path()
	elif courier_count == 1:
		paths.get_child(active_path).get_child(0).set_as_final()


func _on_ReleaseArea_area_entered(area):
	if ball_captured and area.get_parent().name == "Courier":
		ball_captured = false
		var couriers = paths.get_child(active_path).get_children()
		for c in couriers:
			if !c.disabled and !c.is_lead:
				c.enable_collision()
		emit_signal("ball_released")


func _reparent_couriers():
	var old_index
	if active_path == 0:
		old_index = FINAL_PATH_INDEX
	else:
		old_index = active_path - 1
		
	var old_path = paths.get_child(old_index)
	var new_path = paths.get_child(active_path)
	var couriers = old_path.get_children()
	
	for i in couriers.size():
		old_path.remove_child(couriers[i])
		new_path.add_child(couriers[i])
		if active_path < FINAL_PATH_INDEX or couriers[i].is_lead:
			couriers[i].reset()
			if active_path == 2:
				couriers[i].set_as_final()


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
	if active_path < FINAL_PATH_INDEX:
		active_path += 1
	else:
		active_path = 0
	_reparent_couriers()


func reset():
	active_path = 0
	_reparent_couriers()
