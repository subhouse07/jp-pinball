extends Node2D

enum { INIT, WIN, LOSE }

var bg_code : int
var bg_anims = ["init", "win", "lose"]

signal splash_timeout(complete)


func _ready():
	$BgAnimatedSprite.animation = bg_anims[bg_code]


func _on_SplashTimer_timeout():
	var complete = bg_code > INIT
	emit_signal("splash_timeout", complete)
