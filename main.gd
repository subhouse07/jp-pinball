extends Node

export var dev_mode_enabled : bool

var current_scene = "MainBoard"
#var time = 0


func _ready():
	if !dev_mode_enabled:
		$GUILayer/GUI.disable_dev_panel()


#func _process(delta):
#	if not get_tree().paused:
#		time += delta * 1.0


func add_game_scene():
	var scene = load("res://" + current_scene + ".tscn")
	var node = scene.instance()
	$GameScene.add_child(node)


func _on_GameScene_init_dialog(character_id):
	$GUILayer/GUI.init_dialog(character_id)


func _on_GUI_dialog_freed():
	$GameScene.on_dialog_freed(current_scene)
