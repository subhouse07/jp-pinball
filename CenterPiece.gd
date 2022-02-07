extends Node2D

signal special_entered(name)

var frame = 0
var polygon_pv_arr = [ 
	[Vector2(0,48), Vector2(-41,24), Vector2(0,1), Vector2(39,23)],
	[Vector2(-9,47), Vector2(-40,18), Vector2(8,1), Vector2(40,30)],
	[Vector2(-15,47), Vector2(-37,14), Vector2(15,1), Vector2(39,33)],
	[Vector2(-23,44), Vector2(-34,10), Vector2(23,4), Vector2(35,37)],
	[Vector2(-32,41), Vector2(-30,8), Vector2(29,7), Vector2(30,41)],
	[Vector2(-36,38), Vector2(-24,4), Vector2(34,10), Vector2(22,45)],
	[Vector2(-39,36), Vector2(-15,3), Vector2(36,12), Vector2(20,45)],
	[Vector2(-41,31), Vector2(-9,1), Vector2(40,17), Vector2(9,47)]
	]

func _ready():
	$AnimatedSprite.play("default")
	_set_entrance_enabled(false)


func _on_AnimatedSprite_frame_changed():
	frame = (frame + 1) % 8
	$DefaultStaticBody2D/CollisionPolygon2D.polygon = polygon_pv_arr[frame]


func activate_entrance():
	$AnimatedSprite.play("open")


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "open":
		$AnimatedSprite.stop()
		$AnimatedSprite.frame = $AnimatedSprite.frames.get_frame_count("open") - 1
		_set_entrance_enabled(true)


func _on_SpecialEntranceArea_body_entered(body):
	if body.name == "Ball":
		emit_signal("special_entered", Constants.SP_NAME_CENTER)


func _set_entrance_enabled(enabled: bool):
	$SpecialEntrance/SpecialEntranceArea.collision_layer = enabled
	$SpecialEntrance/SpecialEntranceArea.collision_mask = enabled
	$SpecialEntrance.visible = enabled
	$OpenStaticBody2D.collision_layer = enabled
	$OpenStaticBody2D.collision_mask = enabled
	$OpenStaticBody2D2.collision_layer = enabled
	$OpenStaticBody2D2.collision_mask = enabled
	$DefaultStaticBody2D.collision_layer = !enabled
	$DefaultStaticBody2D.collision_mask = !enabled
