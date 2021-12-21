extends Node2D

enum { COPIER, FILES, BRAINSTORM }

var special_trigger : int

signal special_entered(special_name)

func _ready():
	_set_entrance_enabled(false)


func activate_special_stage(task : int):
	$CubeMates.reset()
	match task:
		COPIER:
			$CopierSection.reset()
			_set_entrance_enabled(true)
			special_trigger = COPIER
			# set animation
		FILES:
			$FileCabinets.reset()
			_set_entrance_enabled(true)
			special_trigger = FILES
			# set animation


func _on_SpecialEntranceArea_body_entered(body):
	if body.name == "Ball":
		_set_entrance_enabled(false)
		match special_trigger:
			COPIER:
				emit_signal("special_entered", $"/root/GameState".SP_NAME_COPIER)
			FILES:
				emit_signal("special_entered", $"/root/GameState".SP_NAME_FILES)
			BRAINSTORM:
				emit_signal("special_entered", $"/root/GameState".SP_NAME_BRAINSTORM)


func _set_entrance_enabled(enabled: bool):
	$SpecialEntrance.visible = enabled
	if enabled:
		$SpecialEntrance/SpecialEntranceArea.collision_layer = 1
		$SpecialEntrance/SpecialEntranceArea.collision_mask = 1
	else:
		$SpecialEntrance/SpecialEntranceArea.collision_layer = 0
		$SpecialEntrance/SpecialEntranceArea.collision_mask = 0
