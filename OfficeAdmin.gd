extends Node2D

var desks_lit = [false, false, false]

signal task_activated(area, name)
signal dialog_activated(character_id)

func _ready():
	set_office_admin_enabled(false)


func _on_DeskArea2D_body_entered(body, desk_ind):
	if body.name == "Ball":
		GameState.score("LobbyDesk")
		if !GameState.lobby_task_active:
			desks_lit[desk_ind] = true
			_light_desk(desk_ind)
	if _all_desks_lit():
		GameState.score("AllLobbyDesks")
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
	$OADoor.set_enabled(enabled)


func _on_TrapDoor_ball_trapped():
	if GameState.lobby_basement_ready():
		GameState.lobby_task_ind = Constants.BASEMENT
	else:
		GameState.select_lobby_task()
	GameState.lobby_task_active = true
	emit_signal("dialog_activated", Constants.CHAR_ID_OA)


func on_dialog_freed():
	$OADoor.release_ball()
	GameState.score(self.name)
	emit_signal("task_activated", Constants.AREA_LOBBY, "name")
	set_office_admin_enabled(false)
	reset_desks()
