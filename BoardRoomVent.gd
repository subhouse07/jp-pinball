extends Node2D


var layer = 0
var mask = 0


func _ready():
	layer = $VentStaticBody.collision_layer
	mask = $VentStaticBody.collision_mask
	_set_vent_opened(false)


func reset():
	GameState.reset_boardroom_vent()
	_set_vent_opened(false)


func _on_VentHitArea_body_entered(body):
	if body.name == "Ball" and GameState.hp_state["boardroom_vent"] > 0:
		GameState.score(self.name)
		GameState.hit_boardroom_vent()
		$HitTimer.start()


func _on_HitTimer_timeout():
	_set_vent_opened(true)


func _set_vent_opened(open : bool):
	if open:
		$UpperTrapDoor.set_enabled(true)
		$VentBlockerBody.collision_layer = 0
		$VentBlockerBody.collision_mask = 0
		$VentStaticBody.collision_layer = 0
		$VentStaticBody.collision_mask = 0
	else:
		$UpperTrapDoor.set_enabled(false)
		$VentBlockerBody.collision_layer = layer
		$VentBlockerBody.collision_mask = mask
		$VentStaticBody.collision_layer = layer
		$VentStaticBody.collision_mask = mask
