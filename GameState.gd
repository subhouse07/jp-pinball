extends Node


var ball_remaining = 3
var hp_computer = 3
var hp_boardroom_doors = 3
var hp_centerpiece = 5
var hp_janitor = 3
var hp_boardroom_vent = 1

var main_board_ball_pos := Vector2(126, 144)


func hit_computer():
	hp_computer -= 1


func reset_hp_computer():
	hp_computer = 3


# - - - -	
# Janitor
# - - - - 
func hit_janitor():
	hp_janitor -= 1


func reset_hp_janitor():
	hp_janitor = 3

# - - - - - - - - - 
# Board Room Vent
# - - - - - - - - -
func hit_boardroom_vent():
	hp_boardroom_vent -= 1

func reset_boardroom_vent():
	hp_boardroom_vent = 1


# - - - - - - - - -
# Board Room Doors
# - - - - - - - - -
func hit_boardroom_doors():
	hp_boardroom_doors -= 1


func reset_boardroom_doors():
	hp_boardroom_doors = 3
