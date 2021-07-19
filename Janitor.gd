extends Node2D


var at_closet = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$ClosetDoor/CollisionPolygon2D.disabled = true
	$ClosetDoor.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_BathroomArea_body_entered(body):
	if $HitTimer.is_stopped() and body.name == "Ball":
		$"/root/GameState".hit_janitor()
		$HitTimer.start()
		if $"/root/GameState".hp_janitor <= 0:
			$MoveTimer.start()
		

func _move_janitor_to_closet():
	$"/root/GameState".janitor_to_closet()
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
