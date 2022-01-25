extends Control

var character_id : int
export var bg_size : float


signal dialog_finished

var icon_paths = [
	"res://dialog-icon-test.png",
	"res://dialog-icon-test.png",
	"res://dialog-icon-test.png"
]

var dialog_texts = [
	"Busy day at the office, huh!",
	"I'm your coworker, blah blah ...",
	"I'm some executive, blah blah blah..."
]

func _ready():
	$IconTextureRect.texture = load(icon_paths[character_id])
	$DialogText.text = dialog_texts[character_id]
	$AnimationPlayer.play("BgActivate")


func _on_Timer_timeout():
	var task_code = 0
	emit_signal("dialog_finished")
