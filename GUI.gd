extends Control


var panel_labels = []

func _ready():
	panel_labels = $"/root/GameState".hp_state.keys()
	_populate_dev_panel()


func update():
	for label in panel_labels:
		var spinbox = $DevPanel.get_node("%sSpinBox" % label)
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
	
	$DevPanel.add_child(entry_label)
	$DevPanel.add_child(entry_spinbox)
	
func _on_ToggleButton_toggled(button_pressed):
	$DevPanel.visible = button_pressed

func _on_state_value_changed(value: float, name: String):
	$"/root/GameState".hp_state[name] = value
	var current_focus_control = get_focus_owner()
	if current_focus_control:
		current_focus_control.release_focus()