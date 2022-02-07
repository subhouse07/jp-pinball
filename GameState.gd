extends Node

var score_total : int
var special_state = {
	"cube": {
		"complete": false,
		"stages": {
			Constants.SP_NAME_BRAIN: false,
			Constants.SP_NAME_COPIER: false,
			Constants.SP_NAME_FILES: false,
			Constants.SP_NAME_WORK: true
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
			Constants.LOBBY_TASKS[Constants.LUNCH]: false,
			Constants.LOBBY_TASKS[Constants.NETWORK]: false,
			Constants.LOBBY_TASKS[Constants.TRAFFIC]: false,
			Constants.LOBBY_TASKS[Constants.BASEMENT]: false
		}
	}
}

var hp_state = {
	"boardroom_doors": Constants.BOARDROOM_DOORS_MAX,
	"boardroom_vent": Constants.BOARDROOM_VENT_MAX,
	"centerpiece": Constants.CENTERPIECE_MAX,
	"computer": Constants.COMPUTER_MAX,
	"copier": Constants.COPIER_MAX,
	"file_cab": Constants.FILE_CAB_MAX,
	"janitor": Constants.JANITOR_MAX
}

var mult_state = {
	"Car": { "current": 1, "max": 99 },
	"Elevator": { "current": 1, "max": 18 },
	"WaterCooler": { "current": 1, "max": 16 },
	"WorkComputer": { "current": 1, "max": 16 },
	"DoorManKicker": { "current": 1, "max": 99 },
	"UpperTrapDoor": { "current": 1, "max": 16 },
	"LowerTrapDoor": { "current": 1, "max": 16 },
	"RightCubeMate": { "current": 1, "max": 25 },
	"LeftCubeMate": { "current": 1, "max": 25 },
	"OADoor": { "current": 1, "max": 16 }
}
var lobby_task_ind = 0
var lobby_task_active = false
var lobby_task_targets = {
	Constants.LOBBY_TARGET_TASKS[0]: {
		"CopyWorker": 0,
		"LobbyVisitor": 0,
		"LobbyWorker": 0,
	},
	Constants.LOBBY_TARGET_TASKS[1]: {
		"WaterCooler": 0,
		"Elevator": 0
	}
}
var cube_task_ind = 0 setget cube_task_ind_set, cube_task_ind_get
var cube_task_active = false setget cube_task_active_set, cube_task_active_get

var main_board_ball_pos := Vector2(126, 144)

var gui : Control

func _ready():
	gui = get_parent().get_node("main/GUILayer/GUI")

func score(name : String):
	_check_task_status(name)
	var mult = _check_multiplier(name)
	score_total += Constants.POINTS[name] * mult
	print(score_total)

func increase_mult(name : String, incr: int):
	mult_state[name]["current"] += incr
	if mult_state[name]["current"] > mult_state[name]["max"]:
		mult_state[name]["current"] = mult_state[name]["max"]

func reset_mult(name : String):
	mult_state[name]["current"] = 1

func _check_multiplier(name):
	var mult = 1
	if mult_state.keys().has(name):
		mult = mult_state[name]["current"]
	return mult


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
	hp_state["computer"] = Constants.COMPUTER_MAX
	gui.update()


# - - - -	
# Janitor
# - - - - 
func hit_janitor():
	hp_state["janitor"] -= 1
	gui.update()


func reset_janitor():
	hp_state["janitor"] = Constants.JANITOR_MAX
	gui.update()

# - - - - - - - - - 
# Board Room Vent
# - - - - - - - - -
func hit_boardroom_vent():
	hp_state["boardroom_vent"] -= 1
	gui.update()

func reset_boardroom_vent():
	hp_state["boardroom_vent"] = Constants.BOARDROOM_VENT_MAX
	gui.update()


# - - - - - - - - -
# Board Room Doors
# - - - - - - - - -
func hit_boardroom_doors():
	hp_state["boardroom_doors"] -= 1
	gui.update()


func reset_boardroom_doors():
	hp_state["boardroom_doors"] = Constants.BOARDROOM_DOORS_MAX
	gui.update()


# - - - -
# Copier
# - - - -
func hit_copier():
	hp_state["copier"] -= 1
	gui.update()


func reset_copier():
	hp_state["copier"] = Constants.COPIER_MAX
	gui.update()


# - - - - - - -
# File Cabinet
# - - - - - - -
func hit_file_cabinet():
	hp_state["file_cab"] -= 1
	gui.update()


func reset_file_cab():
	hp_state["file_cab"] = Constants.FILE_CAB_MAX
	gui.update()


# - - - - -
# Cubicle
# - - - - -
func brainstorm_ready():
	var stages = special_state["cube"]["stages"]
	return stages[Constants.SP_NAME_WORK] and stages[Constants.SP_NAME_FILES] \
		and stages[Constants.SP_NAME_COPIER]

func cube_task_ind_set(index: int):
	cube_task_ind = index


func cube_task_ind_get():
	return cube_task_ind


func cube_task_active_set(active: bool):
	cube_task_active = active


func cube_task_active_get():
	return cube_task_active


# - - - -
# Lobby
# - - - -
func _check_task_status(name: String):
	if !lobby_task_active or lobby_task_ind > 1:
		return
	var active_task = lobby_task_targets[Constants.LOBBY_TARGET_TASKS[lobby_task_ind]]
	if active_task.keys().has(name):
		active_task[name] += 1
		_check_lobby_task_completion(active_task)


func _check_lobby_task_completion(active_task: Dictionary):
	var total = 0
	for val in active_task.values():
		total += val
	if total >= Constants.LOBBY_TARGET_TASK_THRESHOLDS[lobby_task_ind]:
		var main_board = get_parent().get_node_or_null("main/GameScene/MainBoard")
		if main_board:
			main_board.lobby_task_complete()
			_reset_lobby_targets(active_task)
		else:
			print("Mainboard doesn't exist")


func _reset_lobby_targets(active_task: Dictionary):
	for key in active_task.keys():
		active_task[key] = 0

func lobby_basement_ready():
	var stages = special_state["lobby"].stages
	return stages[Constants.LOBBY_TASKS[Constants.LUNCH]] and \
		stages[Constants.LOBBY_TASKS[Constants.NETWORK]] and \
		stages[Constants.LOBBY_TASKS[Constants.TRAFFIC]]

func select_lobby_task():
	if lobby_basement_ready():
		lobby_task_ind = Constants.BASEMENT
	else:
		randomize()
		var selected_index = randi() % (Constants.LOBBY_TASKS.size() - 1)
		while special_state["lobby"]["stages"][Constants.LOBBY_TASKS[selected_index]]:
			selected_index = randi() % (Constants.LOBBY_TASKS.size() - 1)
		lobby_task_ind = selected_index
