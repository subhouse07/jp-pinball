extends Node

export var dev_mode_enabled : bool

var current_scene = "MainBoard"
#var time = 0


func _ready():
	add_game_scene()
	if !dev_mode_enabled:
		$GUILayer/GUI.disable_dev_panel()
	
#func _process(delta):
#	if not get_tree().paused:
#		time += delta * 1.0

#func _on_scene_change(name):
#	get_node(current_scene).queue_free()
#	var entrance_name = name + "/" + current_scene
#	get_node("/root/PlayerVariables").enter_pos = get_node("/root/Globals").ENTER_POS[entrance_name]
#	current_scene = name
#	add_game_scene()

func load_scene(new_scene):
	get_node(current_scene).queue_free()
	current_scene = new_scene
	add_game_scene()
	
func add_game_scene():
	var scene = load("res://" + current_scene + ".tscn")
	var node = scene.instance()
	add_child(node)
