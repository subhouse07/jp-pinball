extends Node2D


var at_closet = false


func _ready():
	$ClosetDoor/CollisionPolygon2D.disabled = true
	$ClosetDoor.hide()


func _on_BathroomArea_body_entered(body):
	if $HitTimer.is_stopped() and body.name == "Ball":
		GameState.score(self.name)
		GameState.hit_janitor()
		$HitTimer.start()
		if GameState.hp_state["janitor"] <= 0:
			GameState.score("JanitorMove")
			$MoveTimer.start()


func _move_janitor_to_closet():
	GameState.reset_janitor()
	$BathroomArea/CollisionShape2D.disabled = true
	$SideDivider.hide()
	$SideDivider/CollisionShape2D.disabled = true
	$ClosetDoor/CollisionPolygon2D.disabled = false
	$ClosetDoor.show()


func _move_janitor_to_bathroom():
	$BathroomArea/CollisionShape2D.disabled = false
	$SideDivider.show()
	$SideDivider/CollisionShape2D.disabled = false
	$ClosetDoor/CollisionPolygon2D.disabled = true
	$ClosetDoor.hide()


func _on_MoveTimer_timeout():
	if !at_closet:
		_move_janitor_to_closet()
	else:
		_move_janitor_to_bathroom()
	at_closet = !at_closet


func reset():
	_move_janitor_to_bathroom()
