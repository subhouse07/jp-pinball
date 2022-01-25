extends Control

var character_id : int
export var bg_size : float


signal dialog_finished

var bg_paths = [
	"res://dialog-box-test.png",
	"res://dialog-box-cm.png",
	"res://dialog-box-test.png"
]

var icon_paths = [
	"res://dialog-icon-test.png",
	"res://dialog-icon-test.png",
	"res://dialog-icon-test.png"
]

var dialog_texts = [
	"Busy day at the office, huh!",
	"I'm swamped! Could you help me out with a few things?",
	"I'm some executive, blah blah blah..."
]

func _ready():
	$IconTextureRect.texture = load(icon_paths[character_id])
	$BgTextureRect.texture = load(bg_paths[character_id])
	$DialogText.text = dialog_texts[character_id]
	$AnimationPlayer.play("BgActivate")


func _on_Timer_timeout():
	var task_code = 0
	emit_signal("dialog_finished")
