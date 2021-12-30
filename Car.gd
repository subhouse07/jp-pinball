extends Node2D

enum { VAN, MINI, SPORT, HATCH, TRUCK }

const SPORT_COLLISION = [12, 19]
const MINI_COLLISION = [12, 15]
const VAN_COLLISION = [12, 21]
const HATCH_COLLISION = [12, 20]
const TRUCK_COLLISION = [14, 55]

var car_type
var index : int
var exploding = false

signal hit(index)
signal reset(index)

func _ready():
	adjust_collision_shape()
#	adjust_sprite_hue()
	
func adjust_sprite_hue():
	# Duplicate the shader so that changing its param doesn't change it on any other sprites that also use the shader.
	$Sprite.set_material($Sprite.get_material().duplicate(true))

	# Offset sprite hue by a random value within specified limits.
	var rand_hue = float(randi() % 3)/2.0/3.2
	$Sprite.material.set_shader_param("Shift_Hue", rand_hue)
		

func adjust_collision_shape():
	var collision_shape = $StaticBody2D/CollisionShape2D
	var area_shape = $Area2D/CollisionShape2D
	_set_collisions_enabled(true)
	match car_type:
		VAN:
			collision_shape.shape.radius = VAN_COLLISION[0]
			collision_shape.shape.height = VAN_COLLISION[1]
			area_shape.shape.radius = VAN_COLLISION[0]
			area_shape.shape.height = VAN_COLLISION[1]
		MINI:
			collision_shape.shape.radius = MINI_COLLISION[0]
			collision_shape.shape.height = MINI_COLLISION[1]
			area_shape.shape.radius = MINI_COLLISION[0]
			area_shape.shape.height = MINI_COLLISION[1]
		SPORT:
			collision_shape.shape.radius = SPORT_COLLISION[0]
			collision_shape.shape.height = SPORT_COLLISION[1]
			area_shape.shape.radius = SPORT_COLLISION[0]
			area_shape.shape.height = SPORT_COLLISION[1]
		TRUCK:
			collision_shape.shape.radius = TRUCK_COLLISION[0]
			collision_shape.shape.height = TRUCK_COLLISION[1]
			$Area2D.collision_layer = 0
			$Area2D.collision_mask = 0
		HATCH:
			collision_shape.shape.radius = HATCH_COLLISION[0]
			collision_shape.shape.height = HATCH_COLLISION[1]
			area_shape.shape.radius = HATCH_COLLISION[0]
			area_shape.shape.height = HATCH_COLLISION[1]


func _set_collisions_enabled(enabled: bool):
	var static_body = $StaticBody2D
	var area = $Area2D
	
	if enabled:
		static_body.collision_layer = 1
		static_body.collision_mask = 1
		area.collision_layer = 1
		area.collision_mask = 1
	else:
		static_body.collision_layer = 0
		static_body.collision_mask = 0
		area.collision_layer = 0
		area.collision_mask = 0


func _on_Area2D_body_entered(body):
	if body.name == "Ball" and !exploding:
		exploding = true
		$Sprite.hide()
		$ExplodeSprite.show()
		$ExplodeSprite.play()
		emit_signal("hit", index)


func _on_ExplodeSprite_animation_finished():
	$ExplodeSprite.stop()
	$ExplodeSprite.hide()
	_set_collisions_enabled(false)
	$ResetTimer.start()


func _on_ResetTimer_timeout():
	exploding = false
	_set_collisions_enabled(true)
	emit_signal("reset", index)
	$Sprite.show()
