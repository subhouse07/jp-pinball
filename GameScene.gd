extends Node2D

var special_scene_name = ""
var special_area = ""

signal init_dialog(character_id)

func _ready():
	load_main_board()


func _on_dialog_requested(character_id: int):
	emit_signal("init_dialog", character_id)

func on_dialog_freed(current_scene: String):
	get_node(current_scene).on_dialog_freed()

func _on_special_triggered(area_name: String, special_name: String):
	# do a scene transition?
	# instance the appropriate scene
	# connect it to "_on_special_complete(success)"
	var main_board = get_node_or_null("MainBoard")
	if main_board:
		special_scene_name = special_name
		special_area = area_name
		main_board.queue_free()
		var scene = load("res://SpecialStage.tscn")
		var special_stage = scene.instance()
		special_stage.stage_scene_name = special_name
		special_stage.connect("special_complete", self, "_on_special_complete")
		add_child(special_stage)


func _on_special_complete(success: bool):
	# change GameState values if needed (special stage success)
	# do a scene transition back to main board
	# instance main board
	# get ball entrance position from GameState
	# maybe MainBoard does this stuff in ready. Will have to see what variables
	# actually need to be set when returning from a stage
	
	var special_stage = get_node_or_null("SpecialStage")
	if special_stage:
		if success:
			GameState.complete_special_stage(special_area, special_scene_name)
		special_stage.queue_free()
		load_main_board()

func load_main_board():
	var scene = load("res://MainBoard.tscn")
	var main_board = scene.instance()
	main_board.connect("special_triggered", self, "_on_special_triggered")
	main_board.connect("dialog_requested", self, "_on_dialog_requested")
	add_child(main_board)
