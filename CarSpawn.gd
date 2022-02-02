extends Node2D

const MAX_CAR_NODES = 10
var count = 0
var speed = 100
var sprite_resources = []
var car_unit_speed = 0.4
var car_nodes = []
var moving = []
var node_paths = []

func _ready():
	randomize()
	
	sprite_resources.append(preload("res://redvan.png"))       # 0
	sprite_resources.append(preload("res://redcooper.png"))    # 1
	sprite_resources.append(preload("res://redsport.png"))     # 2
	sprite_resources.append(preload("res://silverhatch.png"))  # 3
	sprite_resources.append(preload("res://bluetruck.png"))    # 4
	
	_populate_car_nodes()
	_populate_path_follows()
	$Timer.start()


func _process(delta):
	for i in MAX_CAR_NODES:
		if moving[i]:
			var follow_node = node_paths[i]
			var new_unit_offset = follow_node.unit_offset + car_unit_speed * delta
			if new_unit_offset >= 1.0:
				_end_car_movement(i)
			else:
				follow_node.unit_offset = new_unit_offset


func _select_car():
	var rand_select = randi() % 100
	if rand_select < 5:
		return 4
	else:
		return rand_select % 4


func _populate_car_nodes():
	for i in MAX_CAR_NODES:
		var car_scene = load("res://Car.tscn")
		var car_node = car_scene.instance()
		var car_type = _select_car()
		car_node.car_type = car_type
		car_node.index = i
		car_node.get_node("Sprite").texture = sprite_resources[car_type]
		car_node.connect("hit", self, "_on_Car_hit")
		car_node.connect("reset", self, "_on_Car_reset")
		car_nodes.append(car_node)
		moving.append(false)


func _populate_path_follows():
	for i in MAX_CAR_NODES:
		var path_follow = PathFollow2D.new()
		
		# Visibility Notifier won't work because cars wont always be visible,
		# but they should still be moving
		
		path_follow.add_child(car_nodes[i])
		var path_select = i % 2
		if path_select == 0:
			$Path2D.add_child(path_follow)
			node_paths.append(path_follow)
		else:
			$Path2D2.add_child(path_follow)
			node_paths.append(path_follow)


func _end_car_movement(index):
	moving[index] = false
	var follow_node = node_paths[index]
	var car_node = follow_node.get_child(0)
	var car_type = _select_car()
	follow_node.offset = 0
	car_node.car_type = car_type
	car_node.get_node("Sprite").texture = sprite_resources[car_type]
	car_node.call("adjust_collision_shape")
	car_node.call("adjust_sprite_hue")


func _on_Timer_timeout():
	$Timer.wait_time = rand_range(1.0, 2.0)
	for i in MAX_CAR_NODES:
		if !moving[i]:
			moving[i] = true
			return
	$Timer.start()


func _on_Car_hit(index: int):
	moving[index] = false


func _on_Car_reset(index: int):
	_end_car_movement(index)


func _on_Area2D_body_exited(body):
	if body.name == "Ball":
		GameState.reset_mult("Car")
