extends Control

enum { LOBBY_CONE, CUBE_CONE, BRDROOM_CONE }
enum { COPIER, FILES }

const MAIN_BOARD_PATH = "../../../GameScene/MainBoard"

var panel_labels = []
var panel_grid : Node
var cube_task_count = 0

func _ready():
	panel_grid = $PanelContainer/ScrollContainer/DevPanelGrid
	panel_labels = $"/root/GameState".hp_state.keys()
	_populate_dev_panel()


func update():
	for label in panel_labels:
		var spinbox = panel_grid.get_node("%sSpinBox" % label)
		spinbox.value = $"/root/GameState".hp_state[label]


func _populate_dev_panel():
	for label in panel_labels:
		_add_state_entry(label)


func _add_state_entry(label):
	var entry_label = Label.new()
	entry_label.text = label
	entry_label.name = String("%sLabel" % label)
	
	var entry_spinbox = SpinBox.new()
	entry_spinbox.value = $"/root/GameState".hp_state[label]
	entry_spinbox.name = String("%sSpinBox" % label)
	
	entry_spinbox.connect("value_changed", self, "_on_state_value_changed", [label])
	
	panel_grid.add_child(entry_label)
	panel_grid.add_child(entry_spinbox)


func _on_ToggleButton_toggled(button_pressed):
	$PanelContainer.visible = button_pressed


func _on_state_value_changed(value: float, name: String):
	$"/root/GameState".hp_state[name] = value
	var current_focus_control = get_focus_owner()
	if current_focus_control:
		current_focus_control.release_focus()


func _on_ConeCheckBox_toggled(button_pressed, cone_id):
	match cone_id:
		LOBBY_CONE:
			_set_blocking_cones_enabled(button_pressed, "LobbyBlockingCones")
			pass
		CUBE_CONE:
			_set_blocking_cones_enabled(button_pressed, "CubicleBlockingCones")
			pass
		BRDROOM_CONE:
			_set_blocking_cones_enabled(button_pressed, "BoardRoomBlockingCones")
			pass


func _set_blocking_cones_enabled(enabled: bool, scene_name: String):
	var main_board = get_node(MAIN_BOARD_PATH)
	if enabled:
		var scene = load("res://" + scene_name + ".tscn")
		var node = scene.instance()
		main_board.add_child(node)
	else:
		main_board.get_node(scene_name).queue_free()


func _on_TaskCheckButton_toggled(button_pressed, task_id):
	var task_node_names = [ "CopierSection", "FileCabinets" ]
	var main_board = get_node(MAIN_BOARD_PATH)
	if button_pressed:
		cube_task_count += 1
		main_board.call("_on_CubeMates_task_activated", task_node_names[task_id])
		main_board.get_node("Cubicle/CubeMates").call("_set_bumpers_enabled", true)
	else:
		cube_task_count -= 1
		main_board.get_node("Cubicle/%s" % task_node_names[task_id]).reset()
		if cube_task_count <= 0:
			main_board.get_node("Cubicle/CubeMates").reset()



func _on_CourPathButton_pressed():
	var courier_coordinator = get_node("%s/CourierCoordinator" % MAIN_BOARD_PATH)
	courier_coordinator.go_to_next_path()
