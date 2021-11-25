extends Control

enum { LOBBY_CONE, CUBE_CONE, BRDROOM_CONE }

var panel_labels = []

func _ready():
	panel_labels = $"/root/GameState".hp_state.keys()
	_populate_dev_panel()


func update():
	for label in panel_labels:
		var spinbox = $DevPanelGrid.get_node("%sSpinBox" % label)
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
	
	$DevPanelGrid.add_child(entry_label)
	$DevPanelGrid.add_child(entry_spinbox)
	
func _on_ToggleButton_toggled(button_pressed):
	$DevPanelGrid.visible = button_pressed

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
	if enabled:
		var scene = load("res://" + scene_name + ".tscn")
		var node = scene.instance()
		get_node("../../../MainBoard").add_child(node)
	else:
		get_node("../../../MainBoard/%s" % scene_name).queue_free()
