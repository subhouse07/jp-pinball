extends PathFollow2D

const COLLISION_MASK_ENABLE = 1
const COLLISION_LAYER_ENABLE = 1
const COLLISION_MASK_DISABLE = 0
const COLLISION_LAYER_DISABLE = 0

export var index: int
export var is_lead = false

var in_slow_zone = false
var disabled = false
var unit_speed = 0.13
var init_unit_offset : float
var final = false

signal hit(index)
signal captured_ball(index)

func _ready():
	if is_lead:
#		disabled = true
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
			emit_signal("captured_ball", index)
		elif !is_lead or final: # Collide and disable collision
			disabled = true
			$Sprite.modulate.g = 0
			$Sprite.modulate.b = 0
			$CollisionTimer.start()


func reset():
	unit_offset = init_unit_offset
	$Sprite.modulate.g = 255
	$Sprite.modulate.b = 255
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
#	disabled = false
	$StaticBody2D.collision_layer = COLLISION_LAYER_ENABLE
	$StaticBody2D.collision_mask = COLLISION_LAYER_ENABLE


func disable_collision():
	$StaticBody2D.collision_layer = COLLISION_LAYER_DISABLE
	$StaticBody2D.collision_mask = COLLISION_LAYER_DISABLE


func _on_CollisionTimer_timeout():
	disable_collision()
	emit_signal("hit", index)
