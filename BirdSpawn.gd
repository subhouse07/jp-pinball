extends Node2D

enum { BLDG, WIRE }
const WIRE_BIRD_MAX = 16
const WIRE_X_BOUNDS = [30, 355]

var wire_y_vals = [285, 272]

var unit_speed = 0.3
var slots_full = false
var bird_slots = [
	{
		"open": true,
		"pos": Vector2(5, 248),
		"area": BLDG
	},
	{
		"open": true,
		"pos": Vector2(14, 248),
		"area": BLDG
	},
	{
		"open": true,
		"pos": Vector2(23, 248),
		"area": BLDG
	},
	{
		"open": true,
		"pos": Vector2(33, 248),
		"area": BLDG
	},
]
var wire_birds = []
var bldg_birds = []
var bird_scene = preload("res://Bird.tscn")

func _ready():
	_create_wire_slots()

func _process(delta):
	var new_offset = $Path2D/PathFollow2D.unit_offset + unit_speed * delta
	if new_offset >= 1.0:
		$Path2D/PathFollow2D.unit_offset = new_offset - 1.0
	else:
		$Path2D/PathFollow2D.unit_offset = new_offset

func dismiss_wire_birds():
	$SpawnTimer.stop()
	for slot in bird_slots:
		if slot["area"] == WIRE:
			slot["open"] = true
	$DismissTimer.start()


func _dismiss_all_birds(bird_arr : Array):
	for bird in bird_arr:
		bird.fly_away()
	bird_arr.clear()
	$SpawnTimer.one_shot = false
	$SpawnTimer.start()


func _on_SpawnTimer_timeout():
	var bird_slot = _select_bird_slot_or_null()
	if bird_slot:
		var bird = bird_scene.instance()
		bird.destination = bird_slot["pos"]
		bird.global_position = $Path2D/PathFollow2D.global_position
		if bird_slot["area"] == BLDG:
			bldg_birds.append(bird)
		else:
			wire_birds.append(bird)
		add_child(bird)
	else:
		$SpawnTimer.one_shot = true


func _select_bird_slot_or_null():
	var chk_order = _get_shuffled_order()
	for i in chk_order:
		if bird_slots[i]["open"]:
			bird_slots[i]["open"] = false
			return bird_slots[i]
	return null

func _get_shuffled_order():
	var chk_order = []
	for i in bird_slots.size():
		chk_order.append(i)
	for i in chk_order.size()-1:
		var j = i + randi() % (chk_order.size() - i)
		var k = chk_order[i]
		chk_order[i] = chk_order[j]
		chk_order[j] = k
	return chk_order


func _on_Area2D_area_entered(area):
	if area.name == "BirdArea":
		area.get_parent().queue_free()


func _create_wire_slots():
	for i in WIRE_BIRD_MAX:
		var x = WIRE_X_BOUNDS[0] + i*WIRE_BIRD_MAX + randi() % ((WIRE_X_BOUNDS[1] - WIRE_X_BOUNDS[0]) / WIRE_BIRD_MAX)
		var wire_select = randi() % 2
		var new_slot = { "open": true, "pos": Vector2(x, wire_y_vals[wire_select]), "area": WIRE }
		bird_slots.append(new_slot)


func _on_DismissTimer_timeout():
	_dismiss_all_birds(wire_birds)
