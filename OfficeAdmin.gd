extends Node2D

var desks_lit = [false, false, false]

signal task_activated(area, name)

func _ready():
	set_office_admin_enabled(false)


func _on_DeskArea2D_body_entered(body, desk_ind):
	if body.name == "Ball":
		desks_lit[desk_ind] = true
		_light_desk(desk_ind)
	if _all_desks_lit():
		set_office_admin_enabled(true)


func _light_desk(desk_ind : int):
	$Desks.get_child(desk_ind).get_node("LitSprite").show()


func _all_desks_lit():
	for i in desks_lit.size():
		if !desks_lit[i]:
			return false
	return true


func reset_desks():
	for i in desks_lit.size():
		desks_lit[i] = false
		$Desks.get_child(i).get_node("LitSprite").hide()


func set_office_admin_enabled(enabled : bool):
	$OASprite.visible = enabled
	if enabled:
		$OAArea2D.collision_layer = 1
		$OAArea2D.collision_mask = 1
	else:
		$OAArea2D.collision_layer = 0
		$OAArea2D.collision_mask = 0


func _on_OAArea2D_body_entered(body):
	if body.name == "Ball":
		# This should signal the contact dialog to start
		# After that finishes, the following code will execute.
		emit_signal("task_activated", $"/root/GameState".AREA_LOBBY, "name")
		print("OA encountered. Resetting OA")
		set_office_admin_enabled(false)
		print("No tasks available now, so resetting desk state")
		reset_desks()
