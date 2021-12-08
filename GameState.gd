extends Node

const BOARDROOM_DOORS_MAX = 3
const BOARDROOM_VENT_MAX = 1
const CENTERPIECE_MAX = 5
const COMPUTER_MAX = 3
const COPIER_MAX = 3
const FILE_CAB_MAX = 6
const JANITOR_MAX = 3

var special_state = {
	"cube": {
		"complete": false,
		"stages": {
			"copier": false,
			"file_cab": false,
			"my_work": false
		},
	},
	"boardroom": {
		"complete": false,
		"stages": {
			"dungeon": false,
			"boss": false
		}
	},
	"lobby": {
		"complete": false,
		"stages": {
			"sewer": false,
			"centerpiece": false,
			"networking": false,
			"lunch": false,
			"traffic": false
		}
	}
}

var hp_state = {
	"boardroom_doors": BOARDROOM_DOORS_MAX,
	"boardroom_vent": BOARDROOM_VENT_MAX,
	"centerpiece": CENTERPIECE_MAX,
	"computer": COMPUTER_MAX,
	"copier": COPIER_MAX,
	"file_cab": FILE_CAB_MAX,
	"janitor": JANITOR_MAX
}

var main_board_ball_pos := Vector2(126, 144)

var gui : Control

func _ready():
	gui = get_parent().get_node("main/GUILayer/GUI")


func complete_special_stage(area: String, name: String):
	special_state[area]["stages"][name] = true
	var area_complete = true
	for stage in special_state[area]["stages"].keys():
		if !special_state[area]["stages"][stage]:
			area_complete = false
			break
	
	if area_complete:
		special_state[area]["complete"] = true


func hit_computer():
	hp_state["computer"] -= 1
	gui.update()


func reset_computer():
	hp_state["computer"] = COMPUTER_MAX
	gui.update()


# - - - -	
# Janitor
# - - - - 
func hit_janitor():
	hp_state["janitor"] -= 1
	gui.update()


func reset_janitor():
	hp_state["janitor"] = JANITOR_MAX
	gui.update()

# - - - - - - - - - 
# Board Room Vent
# - - - - - - - - -
func hit_boardroom_vent():
	hp_state["boardroom_vent"] -= 1
	gui.update()

func reset_boardroom_vent():
	hp_state["boardroom_vent"] = BOARDROOM_VENT_MAX
	gui.update()


# - - - - - - - - -
# Board Room Doors
# - - - - - - - - -
func hit_boardroom_doors():
	hp_state["boardroom_doors"] -= 1
	gui.update()


func reset_boardroom_doors():
	hp_state["boardroom_doors"] = BOARDROOM_DOORS_MAX
	gui.update()


# - - - -
# Copier
# - - - -
func hit_copier():
	hp_state["copier"] -= 1
	gui.update()


func reset_copier():
	hp_state["copier"] = COPIER_MAX
	gui.update()


# - - - - - - -
# File Cabinet
# - - - - - - -
func hit_file_cabinet():
	hp_state["file_cab"] -= 1
	gui.update()


func reset_file_cab():
	hp_state["file_cab"] = FILE_CAB_MAX
	gui.update()
