extends PathFollow2D

const COLLISION_MASK_ENABLE = 1
const COLLISION_LAYER_ENABLE = 1
const COLLISION_MASK_DISABLE = 0
const COLLISION_LAYER_DISABLE = 0

export var index: int
export var is_lead = false

var in_slow_zone = false
var disabled = false
var final_courier = false
var unit_speed = 0.15

signal hit(index)
signal captured_ball(index)

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_lead:
		$StaticBody2D.collision_layer = COLLISION_LAYER_DISABLE
		$StaticBody2D.collision_mask = COLLISION_LAYER_DISABLE


func _physics_process(delta):
	var new_offset = unit_offset + unit_speed * delta
	if new_offset > 1.0:
		unit_offset = 0
	else:
		unit_offset = new_offset


func _on_Area2D_body_entered(body):
	if body.name == "Ball" and !disabled and !in_slow_zone:
		if is_lead and !final_courier:
			emit_signal("captured_ball", index)
		else: # Collide and disable collision
			disabled = true
			$Sprite.hide()
			$CollisionTimer.start()
			

func reset():
	final_courier = false
	disabled = false
	$Sprite.show()
	if index == 0:
		disable_collision()
	else:
		enable_collision()
		is_lead = false
	

func set_as_lead():
	is_lead = true
	disable_collision()
	
func set_as_final():
	final_courier = true
	enable_collision()

func enable_collision():
	$StaticBody2D.collision_layer = COLLISION_LAYER_ENABLE
	$StaticBody2D.collision_mask = COLLISION_LAYER_ENABLE
	

# disable this courier, emit a signal so the following courier can be made the leader of a group
func disable_collision():
	$StaticBody2D.collision_layer = COLLISION_LAYER_DISABLE
	$StaticBody2D.collision_mask = COLLISION_LAYER_DISABLE
	

func _on_CollisionTimer_timeout():
	disable_collision()
	emit_signal("hit", index)
