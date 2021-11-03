extends Node2D

signal copier_hit

var lifts : Array
var active_lifts = 0

func _ready():
	lifts = $Lifts.get_children()


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
	$LiftWorkers/YSort.get_child(active_lift).get_child(0).set_active(true)
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
				$LiftWorkers/YSort.get_child(check_index).get_child(0).set_active(true)
				active_lifts += 1
				break


func _on_CopyWorkArea_body_entered(body):
	# Check if someone is already in the work area
	# if so, tell the person who just entered to stop and wait
	# add them to a queue
	# when the current worker is finished, the next in line can proceed.
	pass


func _on_CopyWorkArea_area_entered(area):
	pass


func _on_CopyWorker_worker_hit(ind):
	if lifts[ind].activated:
		lifts[ind].deactivate()
		active_lifts -= 1
