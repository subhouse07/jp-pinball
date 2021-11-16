extends Node2D

enum { COPIER, FILES, BRAINSTORM }

func _ready():
	pass # Replace with function body.

func activate_special_stage(task : int):
	$CubeMates.reset()
	match task:
		COPIER:
			$CopierSection.reset()
			print("Congrats, you triggered the Copier special stage")
			# set animation
		FILES:
			$FileCabinets.reset()
			print("Congrats, you triggered the Files special stage")
			# set animation
