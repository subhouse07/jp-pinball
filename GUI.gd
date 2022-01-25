extends Control


func _ready():
	pass # Replace with function body.


func disable_dev_panel():
	if $DevPanel:
		$DevPanel.queue_free()

func update():
	if $DevPanel:
		$DevPanel.update()

func init_dialog(character_id : int):
	var scene = load("res://Dialog.tscn")
	var dialog = scene.instance()
	dialog.character_id = character_id
	add_child(dialog)
