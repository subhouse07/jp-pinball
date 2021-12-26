extends Node2D

const HP_MAX = 6
var hp = HP_MAX

signal hit

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
		emit_signal("hit")
		if hp == 0:
			# here we need to transition this node to the special entrance phase
			# for now just reset()
			print("Brainstorm entrance triggered")
			reset()
