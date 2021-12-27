extends Node2D

const CROWD_INIT_X = -15
const BALL_RELEASE_X = 194

var crowd_moving = false
var crowd_pos := Vector2(0,0)
var man_pos := Vector2(0,0)

signal ball_retrieved
signal ball_released
signal right_return_entered


func _ready():
	crowd_pos = $CrowdArea.global_position

func _process(delta):
	if crowd_moving:
		crowd_pos = $CrowdArea.global_position


func _on_RetriavalArea_body_entered(body):
	if body.name == "Ball":
		# trigger crowd animation and start moving toward train
		init_crowd_tween()
		pass


func _on_CrowdArea_body_entered(body):
	if body.name == "Ball":
		emit_signal("ball_retrieved")


func init_crowd_tween():
	var init_pos = $CrowdArea.position
	var final_pos = Vector2(BALL_RELEASE_X, init_pos.y)
	$Tween.interpolate_property($CrowdArea, "position", init_pos, final_pos, 3)
	$Tween.start()
	crowd_moving = true


func _on_Tween_tween_completed(object, key):
	# trigger crowd entering train animation
	if object == $CrowdArea:
		$CrowdArea/Sprite.play("default")
		crowd_moving = false
		emit_signal("ball_released")
	else:
		emit_signal("ball_released")


func _on_Sprite_animation_finished():
	if $CrowdArea/Sprite.animation == "default":
		$CrowdArea/Sprite.stop()
		$CrowdArea/Sprite.frame = 0
		$CrowdArea.position = Vector2(CROWD_INIT_X, $CrowdArea.position.y)


func _on_RightRetrievalArea_body_entered(body):
	if body.name == "Ball":
		emit_signal("right_return_entered")
		# emit a signal so mainboard cancels linear_velocity.x and hides ball
		# show man sprite and trigger fall animation
		# when animation finishes emit a signal that ball is returning to train
		# Tween man_pos to the train coords
		# in mainboard set ball pos to man_pos
		# emit signal when tween ends and drop ball into train

func move_man(init_pos):
	var final_pos = Vector2(BALL_RELEASE_X, init_pos.y)
	man_pos = init_pos
	$Tween.interpolate_property(self, "man_pos", init_pos, final_pos, 3)
	$Tween.start()
