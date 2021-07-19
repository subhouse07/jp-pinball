extends Node2D


var visitor_paths = []
var worker_paths = []


# Called when the node enters the scene tree for the first time.
func _ready():
	worker_paths = $WorkerPaths.get_children()
	visitor_paths = $VisitorPaths.get_children()
	for w in worker_paths:
		var timer = w.get_node("LobbyWorker/WorkTimer")
		var index = w.get_node("LobbyWorker").index
		
		timer.wait_time += timer.wait_time * index
		timer.start()


func _on_MeetingArea_area_entered(area):
	if area.name == "VisitorArea":
		if !visitor_paths[area.get_parent().index].get_node("LobbyVisitor").worker_hit:
			var worker = worker_paths[area.get_parent().index].get_node("LobbyWorker")
			worker.with_visitor = true
			worker.waiting_for_visitor = false
	elif area.name == "WorkerArea":
		var visitor = visitor_paths[area.get_parent().index].get_node("LobbyVisitor")
		if visitor.waiting:
			visitor.waiting = false
			visitor.enable_collision()
		else:
			area.get_parent().waiting_for_visitor = true
		


func _on_VisitorWaitingArea_area_entered(area):
	if area.name == "VisitorArea":
		if !worker_paths[area.get_parent().index].get_node("LobbyWorker").waiting_for_visitor:
			area.get_parent().waiting = true
			area.get_parent().disable_collision()


func _on_LobbyWorker_desk_reached(index):
	var timer = worker_paths[index].get_node("LobbyWorker/WorkTimer")
	timer.wait_time += $VisitTimers.get_child(0).wait_time
	worker_paths[index].get_node("LobbyWorker/WorkTimer").start()


func _on_DeskArea_area_entered(area):
	if area.name == "VisitorArea":
		if !area.get_parent().worker_hit:
			area.get_parent().visiting = true
			$VisitTimers.get_child(area.get_parent().index).start()


func _on_VisitTimer_timeout(index):
	visitor_paths[index].get_node("LobbyVisitor").visiting = false
	worker_paths[index].get_node("LobbyWorker").with_visitor = false


func reset():
	for w in worker_paths:
		w.get_node("LobbyWorker").reset()
	for v in visitor_paths:
		v.get_node("LobbyVisitor").reset()


func _on_LobbyWorker_worker_hit(index):
	var visitor = visitor_paths[index].get_node("LobbyVisitor")
	visitor.visiting = false
	visitor.waiting = false
	visitor.worker_hit = true


func _on_VisitorVanishArea_area_entered(area):
	if area.name == "VisitorArea":
		var visitor = visitor_paths[area.get_parent().index].get_node("LobbyVisitor")
		visitor.worker_hit = false


func _on_LobbyVisitor_visitor_hit(index):
	var worker = worker_paths[index].get_node("LobbyWorker")
	worker.with_visitor = false
