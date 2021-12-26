extends Node2D



const HP_MAX = 6
var hp = HP_MAX
var entr_pos := Vector2(200, -343)

onready var entrance_shader = preload("res://PH_entrance.shader")

signal hit(finished)

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	_set_collisions_enabled(false)

func activate_task():
	$BrainSprite.play()
	$BrainSprite/ShadowSprite.play()
	visible = true
	_set_collisions_enabled(true)


func reset():
	visible = false
	$BrainSprite.stop()
	$BrainSprite/ShadowSprite.stop()
	_set_collisions_enabled(false)
	hp = HP_MAX


func _set_collisions_enabled(enabled: bool):
	if enabled:
		$StaticBody2D.collision_layer = 1
		$StaticBody2D.collision_mask = 1
		$BrainArea.collision_layer = 1
		$BrainArea.collision_mask = 1
	else:
		$StaticBody2D.collision_layer = 0
		$StaticBody2D.collision_mask = 0
		$BrainArea.collision_layer = 0
		$BrainArea.collision_mask = 0


func _on_BrainArea_body_entered(body):
	if body.name == "Ball":
		hp -= 1
		emit_signal("hit", hp == 0)

func transition_to_special():
	_set_collisions_enabled(false)
	$Tween.interpolate_property(self, "position", position, entr_pos, 2, \
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	

func _on_Tween_tween_completed(object, key):
	$BrainSprite.material.shader = entrance_shader
