extends Node2D


var ball_captured = false
var capture_index
var capture_coords := Vector2()
var active_path = 0
var courier_count

signal ball_captured
signal ball_released

# Called when the node enters the scene tree for the first time.
func _ready():
	courier_count = $CourierPaths/Path2D.get_child_count()


func _physics_process(delta):
	if ball_captured:
		capture_coords = $CourierPaths.get_child(active_path).get_child(capture_index).global_position


func _on_Courier_captured_ball(index):
	var couriers = $CourierPaths.get_child(active_path).get_children()
	for c in couriers:
		c.disable_collision()
	capture_index = index
	ball_captured = true
	capture_coords = couriers[index].global_position
	emit_signal("ball_captured")


func _on_Courier_hit(index):
	courier_count -= 1
	if courier_count <= 0:
		courier_count = $CourierPaths.get_child(active_path).get_child_count()
		active_path += 1
		_reparent_couriers()
	elif courier_count == 1:
		$CourierPaths.get_child(active_path).get_child(0).set_as_final()
#	else:
#		var couriers = $CourierPaths.get_child(active_path).get_children()
#		if couriers.size() > index + 1 and !couriers[index+1].disabled:
#			couriers[index+1].set_as_lead()


func _on_ReleaseArea_area_entered(area):
	
	if ball_captured and area.get_parent().index == capture_index:
		ball_captured = false
		var couriers = $CourierPaths.get_child(active_path).get_children()
		for c in couriers:
			if !c.disabled and !c.is_lead:
				c.enable_collision()
		emit_signal("ball_released")
		
func _reparent_couriers():
	var old_path = $CourierPaths.get_child(active_path-1)
	var new_path = $CourierPaths.get_child(active_path)
	var couriers = old_path.get_children()
	
	for child in couriers:
		child.reset()
		old_path.remove_child(child)
		new_path.add_child(child)
	


func _on_SlowdownArea_area_entered(area):
	if area.name == "CourierArea":
		var node = area.get_parent()
		node.hide()
		node.unit_speed /= 3.0
		if !node.disabled:
			node.in_slow_zone = true
			node.disable_collision()
		

func _on_SlowdownArea_area_exited(area):
	if area.name == "CourierArea":
		var node = area.get_parent()
		node.show()
		node.unit_speed *= 3.0
		if !node.disabled:
			node.in_slow_zone = false
			node.enable_collision()
