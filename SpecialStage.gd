extends Node2D


var success = false
var stage_scene_name : String

signal special_complete(success)


func _ready():
	_load_splash_screen(true)


func _on_special_success():
	success = true
	_free_special_stage()
	_load_splash_screen(false)


func _on_special_failure():
	success = false
	_free_special_stage()
	_load_splash_screen(false)


func _on_SplashScreen_splash_timeout(complete: bool):
	if complete:
		emit_signal("special_complete", success)
	else:
		_load_special_stage()


func _load_splash_screen(is_init: bool):
	var scene = load("res://SplashScreen.tscn")
	var splash = scene.instance()
	splash.connect("splash_timeout", self, "_on_SplashScreen_splash_timeout")
	if is_init:
		splash.bg_code = splash.INIT
	elif success:
		splash.bg_code = splash.WIN
	else:
		splash.bg_code = splash.LOSE
	add_child(splash)


func _load_special_stage():
	var scene = load("res://%s.tscn" % stage_scene_name)
	var special = scene.instance()
	special.connect("success", self, "_on_special_success")
	special.connect("failure", self, "_on_special_failure")
	var splash = get_node_or_null("SplashScreen")
	if splash:
		splash.queue_free()
	add_child(special)


func _free_special_stage():
	var special = get_node_or_null(stage_scene_name)
	if special:
		special.queue_free()
