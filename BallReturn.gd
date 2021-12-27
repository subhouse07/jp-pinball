extends Node2D

const CROWD_INIT_X = -15
const CROWD_FINAL_X = 194

var crowd_moving = false
var crowd_pos := Vector2(0,0)

signal ball_retrieved
signal ball_released


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
	var final_pos = Vector2(CROWD_FINAL_X, init_pos.y)
	$Tween.interpolate_property($CrowdArea, "position", init_pos, final_pos, 3)
	$Tween.start()
	crowd_moving = true


func _on_Tween_tween_completed(object, key):
	# trigger crowd entering train animation
	$CrowdArea/Sprite.play("default")
	crowd_moving = false
	emit_signal("ball_released")


func _on_Sprite_animation_finished():
	if $CrowdArea/Sprite.animation == "default":
		$CrowdArea/Sprite.stop()
		$CrowdArea/Sprite.frame = 0
		$CrowdArea.position = Vector2(CROWD_INIT_X, $CrowdArea.position.y)
