extends Control




func _ready():
	pass # Replace with function body.


func _on_ToggleButton_toggled(button_pressed):
	$DevPanel.visible = button_pressed
