extends Node2D

signal copier_hit

var lifts : Array
var active_lifts = 0
var worker_q : Array
var copier_in_use = false

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
	$LiftWorkers.get_child(active_lift).get_child(0).set_active(true)
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
				$LiftWorkers.get_child(check_index).get_child(0).set_active(true)
				active_lifts += 1
				break


func _on_CopyWorkArea_area_entered(area):
	if area.name == "SpriteArea":
		var worker = area.get_parent()
		if copier_in_use:
			_queue(worker)
		else:
			copier_in_use = true


func _dequeue():
	var worker = worker_q.pop_front()
	worker.queuing = false


func _queue(worker : Node):
	worker.queuing = true
	worker_q.push_back(worker)


func _on_CopyWorker_worker_hit(ind, at_copier):
	if lifts[ind].activated:
		lifts[ind].deactivate()
		active_lifts -= 1


func _on_CopyWorkArea_area_exited(area):
	if area.name == "SpriteArea":
		if !worker_q.empty():
			_dequeue()
		else:
			copier_in_use = false


func _on_CopyWorker_finished_copying(ind):
	lifts[ind].deactivate()
	active_lifts -= 1
