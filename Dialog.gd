extends Control

var character_id : int

var icon_paths = [
	"res://icon-test.png",
	"res://icon-test.png",
	"res://icon-test.png"
]

var dialog_texts = [
	"I'm the OA, blah blah blah...",
	"I'm your coworker, blah blah ...",
	"I'm some executive, blah blah blah..."
]

func _ready():
	$IconTextureRect.texture = load(icon_paths[character_id])
	$DialogText.text = dialog_texts[character_id]
