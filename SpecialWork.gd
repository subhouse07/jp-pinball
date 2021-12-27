extends Node2D

signal success
signal failure



func _on_SpecialTest_success():
	emit_signal("success")


func _on_SpecialTest_failure():
	emit_signal("failure")
