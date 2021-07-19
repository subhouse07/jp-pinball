extends Node2D


const CUBICLE_LIMIT_Y = -417
const INIT_Y = -24
const SPEED = 100.0
var transporting = false

signal cubicle_reached

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _process(delta):
	if transporting:
		var new_pos_y = global_position.y - SPEED * delta
		if new_pos_y <= CUBICLE_LIMIT_Y:
			new_pos_y = CUBICLE_LIMIT_Y
			transporting = false
			emit_signal("cubicle_reached")
			
		
		global_position.y = new_pos_y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func go_to_cubicle():
	transporting = true
	
func go_to_lobby():
	global_position.y = INIT_Y
