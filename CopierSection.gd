extends Node2D

signal copier_hit

var lifts : Array
var active_lifts = 0

func _ready():
	lifts = $Lifts.get_children()
#	activate_lifts()


func _on_Area2D_body_entered(body):
	if body.name == "Ball":
		emit_signal("copier_hit")


func activate_task():
	activate_lifts()


func activate_lifts():
	randomize()
	var active_lift = randi() % lifts.size()
	lifts[active_lift].activate()
	active_lifts += 1
	$LiftResetTimer.start()


func _on_Lift_lift_hit(ind):
	active_lifts -= 1


func _on_LiftResetTimer_timeout():
	if active_lifts < lifts.size():
		randomize()
		var next_lift = randi()
		for i in lifts.size():
			var check_index = (next_lift + i) % lifts.size()
			if !lifts[check_index].activated:
				lifts[check_index].activate()
				active_lifts += 1
				break
