extends Control

const BG_PATHS = [
	"res://dialog-box-test.png",
	"res://dialog-box-cm.png",
	"res://dialog-box-test.png"
]

const ICON_PATHS = [
	"res://dialog-icon-test.png",
	"res://dialog-icon-test.png",
	"res://dialog-icon-test.png"
]

const DIALOG_TEXTS = [
	"Busy day at the office, huh!",
	"I'm swamped! Could you help me out with a few things?",
	"I'm some executive, blah blah blah..."
]

const TASK_NAMES = [
	[
		"Lunch is on me!",
		"Go, Network!",
		"Office Errands",
		"Office Basement"
	],
	[
		"Makin' copies",
		"I need files.",
		"Do your job!",
		"BRAIN STORM"
	],
	[
		"Task 1",
		"Task 2"
	]
]

var character_id : int

signal dialog_finished

func _ready():
	$IconTextureRect.texture = load(ICON_PATHS[character_id])
	$BgTextureRect.texture = load(BG_PATHS[character_id])
	$DialogText.text = DIALOG_TEXTS[character_id]
	$AnimationPlayer.play("BgActivate")


func _on_Timer_timeout():
	var task_code = 0
	emit_signal("dialog_finished")


func _on_AnimationPlayer_animation_finished(anim_name):
	_add_spinner()
	

func _on_Spinner_finished_spinning():
	$Timer.start()

func _add_spinner():
	var scene = load("res://TaskSpinner.tscn")
	var spinner = scene.instance()
	spinner.task_names = TASK_NAMES[character_id]
	match character_id:
		Constants.CHAR_ID_OA:
			spinner.selected_task_ind = GameState.lobby_task_ind
		Constants.CHAR_ID_CM:
			spinner.selected_task_ind = GameState.cube_task_ind
		Constants.CHAR_ID_EXEC:
			pass
	spinner.connect("finished_spinning", self, "_on_Spinner_finished_spinning")
	add_child(spinner)
