extends Control


func _ready():
	pass # Replace with function body.


func disable_dev_panel():
	if $DevPanel:
		$DevPanel.queue_free()

func update():
	if $DevPanel:
		$DevPanel.update()
