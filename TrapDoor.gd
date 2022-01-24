extends Node2D


export(bool) var is_teleport
export(float) var my_time
export(float) var launch_x
export(float) var launch_y
export(bool) var is_sublvl

var is_trapping = false
var timer
var sprite

var layer = 0
var mask = 0

signal ball_trapped
signal door_timed_out(x, y)


func _ready():
	if is_sublvl:
		layer = 2
		mask = 2
	else:
		layer = 1
		mask = 1
	$Area2D.collision_layer = layer
	$Area2D.collision_mask = mask
	_add_timer()
	sprite = get_node_or_null("Sprite")
	

func _add_timer():
	timer = Timer.new()
	timer.wait_time = my_time
	timer.one_shot = true
	timer.connect("timeout", self, "_on_Timer_timeout")
	add_child(timer)


func _on_Area2D_body_entered(body):
	if body.name == "Ball" and !is_trapping:
		GameState.score(self.name)
		GameState.increase_mult(self.name, 1)
		is_trapping = true
		if sprite:
			sprite.play()
		emit_signal("ball_trapped")
		if !is_teleport:
			timer.start()


func _on_AnimatedSprite_animation_finished():
	sprite.stop()
	if is_teleport and is_trapping:
		is_trapping = false
		sprite.play("default", true)


func _on_Timer_timeout():
	is_trapping = false
	emit_signal("door_timed_out", launch_x, launch_y)
	
func set_enabled(enabled : bool):
	if enabled:
		$Area2D.collision_layer = layer
		$Area2D.collision_mask = mask
	else:
		$Area2D.collision_layer = 0
		$Area2D.collision_mask = 0


func reset():
	GameState.reset_mult(self.name)
