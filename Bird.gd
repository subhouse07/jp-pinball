extends AnimatedSprite

const FLY_AWAY = "fly_away"
const FLY_IN = "fly_in"
const LEFT_LOOK = "left_look_around"
const RIGHT_LOOK = "right_look_around"
const LEFT_JUMP = "left_jump"
const RIGHT_JUMP = "right_jump"

#var in_vec := Vector2()
#var out_vec := Vector2()
var destination := Vector2()

func _ready():
#	var vel_y_mod = 30 + randi() % 70
#	var vel_x_mod = 70 + randi() % 70
#	in_vec = Vector2(vel_x_mod, vel_y_mod)
#	out_vec = Vector2(-vel_x_mod, -vel_y_mod)
	$Tween.interpolate_property(self, "global_position", global_position, destination, 2.0, Tween.TRANS_LINEAR,Tween.EASE_OUT)
	$Tween.start()
	

func fly_away():
	animation = FLY_AWAY

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()


func _on_Tween_tween_completed(object, key):
	var rand = randi() % 2
	if rand == 0:
		animation = LEFT_LOOK
	else:
		animation = RIGHT_LOOK


func _on_Bird_animation_finished():
	if animation == LEFT_LOOK:
		var rand = randi() % 4
		if rand > 0:
			animation = RIGHT_JUMP
	elif animation == RIGHT_LOOK:
		var rand = randi() % 4
		if rand > 0:
			animation = LEFT_JUMP
	elif animation == LEFT_JUMP:
		animation = LEFT_LOOK
	elif animation == RIGHT_JUMP:
		animation = RIGHT_LOOK
