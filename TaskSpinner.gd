extends Control

const COLOR_FONT_INACTIVE = Color(0,0,0,1.0)
const COLOR_SHADOW_INACTIVE = Color(1.0, 1.0, 1.0, 1.0)
const COLOR_FONT_ACTIVE = Color(1.0, 1.0, 1.0, 1.0)
const COLOR_STYLEBOX_BG = Color(0,0,0,1.0)

var rev_count : int = 0
var timeout_count = 0
var task_labels = []
var task_names = [
	"Task 1",
	"Task 2",
	"Task 3",
	"Task 4"
]
var selected_task_ind = 2
var highlight_ind = 0
var highlight_box : StyleBoxFlat

onready var font_data = load("res://Fixedsys Excelsior 3.01 Regular.ttf")

func _ready():
	highlight_box = StyleBoxFlat.new()
	highlight_box.bg_color = COLOR_STYLEBOX_BG
	_populate_label_container()
	$AnimationPlayer.play("ActivateSpinner")

func _populate_label_container():
	var font = DynamicFont.new()
	font.font_data = font_data
	font.size = 18
	for i in task_names.size():
		var label = Label.new()
		label.text = task_names[i]
		label.align = Label.ALIGN_CENTER
		label.set("custom_fonts/font", font)
		task_labels.append(label)
		_unhighlight_label(i)
		$BgTextureRect/VBoxContainer.add_child(label)


func _on_HighlightTimer_timeout():
	print($HighlightTimer.wait_time)
	_unhighlight_label(highlight_ind)
	highlight_ind = (highlight_ind + 1) % task_names.size() 
	_highlight_label(highlight_ind)
	timeout_count += 1
	rev_count = int(timeout_count / task_names.size())
	if rev_count > 5 and highlight_ind == selected_task_ind:
		$HighlightTimer.stop()
	elif rev_count == 5:
		$HighlightTimer.wait_time = 0.25
	elif rev_count == 3:
		$HighlightTimer.wait_time = 0.125


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "ActivateSpinner":
		_highlight_label(highlight_ind)
		$HighlightTimer.start()

func _highlight_label(ind: int):
	task_labels[ind].set("custom_colors/font_color", COLOR_FONT_ACTIVE)
	task_labels[ind].set("custom_colors/font_color_shadow", null)
	task_labels[ind].set("custom_styles/normal", highlight_box)

func _unhighlight_label(ind: int):
	task_labels[ind].set("custom_colors/font_color", COLOR_FONT_INACTIVE)
	task_labels[ind].set("custom_colors/font_color_shadow", COLOR_SHADOW_INACTIVE)
	task_labels[ind].set("custom_styles/normal", null)
