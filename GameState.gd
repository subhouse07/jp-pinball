extends Node


# Declare member variables here. Examples:
var ball_remaining = 3
var hp_computer = 3
var hp_boardroom_doors = 5
var hp_centerpiece = 5
var hp_janitor = 3

var main_board_ball_pos := Vector2(126, 144)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func hit_computer():
	hp_computer -= 1
	
func reset_hp_computer():
	hp_computer = 3
	
# - - - -	
# Janitor
# - - - - 
func hit_janitor():
	hp_janitor -= 1
	
func janitor_to_closet():
	hp_janitor = 3
