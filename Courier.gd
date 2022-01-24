extends PathFollow2D

const COLLISION_MASK_ENABLE = 1
const COLLISION_LAYER_ENABLE = 1
const COLLISION_MASK_DISABLE = 0
const COLLISION_LAYER_DISABLE = 0
const BASE_UNIT_SPEED = 0.13
const FINAL_SPEED_MULT = 1.5

export var index: int
export var is_lead = false

var in_slow_zone = false
var disabled = false
var init_unit_offset : float
var final = false
var unit_speed : float

signal hit
signal captured_ball(index)

func _ready():
	unit_speed = BASE_UNIT_SPEED
	if is_lead:
		disable_collision()
	init_unit_offset = unit_offset


func _physics_process(delta):
	var new_offset = unit_offset + unit_speed * delta
	if new_offset > 1.0:
		unit_offset = 0
	else:
		unit_offset = new_offset


func _on_Area2D_body_entered(body):
	if body.name == "Ball" and !in_slow_zone and !disabled:
		if is_lead and !final:
			GameState.score("CourierCapture")
			emit_signal("captured_ball", index)
		elif !is_lead or final: # Collide and disable collision
			GameState.score("Courier")
			disabled = true
			$Sprite.hide()
			disable_collision()
			$CollisionTimer.start()


func reset():
	unit_offset = init_unit_offset
	$Sprite.show()
	disabled = false
	if is_lead:
		final = false
		disable_collision()
	else:
		enable_collision()

func set_as_final():
	final = true
	enable_collision()


func enable_collision():
	$StaticBody2D.collision_layer = COLLISION_LAYER_ENABLE
	$StaticBody2D.collision_mask = COLLISION_LAYER_ENABLE


func disable_collision():
	$StaticBody2D.collision_layer = COLLISION_LAYER_DISABLE
	$StaticBody2D.collision_mask = COLLISION_LAYER_DISABLE


func _on_CollisionTimer_timeout():
	emit_signal("hit")
