extends Node2D

var driving = false
var unit_speed = 0.42
var task_car_pos := Vector2()

signal traffic_special_entered
signal task_car_captured

func _ready():
	$Path2D/PathFollow2D/AnimatedSprite.hide()
	_set_collisions_enabled(false)
	task_car_pos = $Path2D/PathFollow2D.global_position

func _process(delta):
	if driving:
		$Path2D/PathFollow2D.unit_offset += unit_speed * delta
		task_car_pos = $Path2D/PathFollow2D.global_position
		

func activate():
	_set_collisions_enabled(true)
	$Path2D/PathFollow2D/AnimatedSprite.show()

func _set_collisions_enabled(enabled: bool):
	if enabled:
		$Path2D/PathFollow2D/TaskCarArea.collision_layer = 1
		$Path2D/PathFollow2D/TaskCarArea.collision_mask = 1
		$TrafficEntranceArea.collision_layer = 1
		$TrafficEntranceArea.collision_mask = 1
	else:
		$Path2D/PathFollow2D/TaskCarArea.collision_layer = 0
		$Path2D/PathFollow2D/TaskCarArea.collision_mask = 0
		$TrafficEntranceArea.collision_layer = 0
		$TrafficEntranceArea.collision_mask = 0

func _on_TaskCarArea_body_entered(body):
	if body.name == "Ball":
		emit_signal("task_car_captured")
		$Path2D/PathFollow2D/AnimatedSprite.play()
		driving = true


func _on_AnimatedSprite_animation_finished():
	$Path2D/PathFollow2D/AnimatedSprite.stop()
	$Path2D/PathFollow2D/AnimatedSprite.frame = 2
#	driving = true


func _on_TrafficEntranceArea_area_entered(area):
	if area.name == "TaskCarArea":
		driving = false
		emit_signal("traffic_special_entered")


func _on_TurningArea_area_entered(area):
	if area.name == "TaskCarArea":
		$Path2D/PathFollow2D.rotate = true
		$Path2D/PathFollow2D/AnimatedSprite.rotation_degrees = 90
