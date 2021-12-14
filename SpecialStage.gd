extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal special_complete(success)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SplashTimer_timeout():
	emit_signal("special_complete", true)
