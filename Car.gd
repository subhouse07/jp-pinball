extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum { VAN, MINI, SPORT, HATCH, TRUCK }

const SPORT_COLLISION = [12, 19]
const MINI_COLLISION = [12, 15]
const VAN_COLLISION = [12, 21]
const HATCH_COLLISION = [12, 20]
const TRUCK_COLLISION = [14, 55]




var car_type

# Called when the node enters the scene tree for the first time.
func _ready():
	adjust_collision_shape()
	adjust_sprite_hue()
	
func adjust_sprite_hue():
	# Duplicate the shader so that changing its param doesn't change it on any other sprites that also use the shader.
# Generally done once in _ready()
	$Sprite.set_material($Sprite.get_material().duplicate(true))

# Offset sprite hue by a random value within specified limits.
	var rand_hue = float(randi() % 3)/2.0/3.2
	$Sprite.material.set_shader_param("Shift_Hue", rand_hue)
		

func adjust_collision_shape():
	var collision_shape = $StaticBody2D/CollisionShape2D
	match car_type:
		VAN:
			collision_shape.shape.radius = VAN_COLLISION[0]
			collision_shape.shape.height = VAN_COLLISION[1]
		MINI:
			collision_shape.shape.radius = MINI_COLLISION[0]
			collision_shape.shape.height = MINI_COLLISION[1]
		SPORT:
			collision_shape.shape.radius = SPORT_COLLISION[0]
			collision_shape.shape.height = SPORT_COLLISION[1]
		TRUCK:
			collision_shape.shape.radius = TRUCK_COLLISION[0]
			collision_shape.shape.height = TRUCK_COLLISION[1]
		HATCH:
			collision_shape.shape.radius = HATCH_COLLISION[0]
			collision_shape.shape.height = HATCH_COLLISION[1]
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
