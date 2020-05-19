extends Node

enum TargetMode {MOUSE, JOYPAD}
var mode = TargetMode.JOYPAD

func _ready():
	if Input.get_connected_joypads():
		_set_target_mode_joypad()
	else:
		_set_target_mode_mouse()

func _input(event):
	if Input.is_action_just_released("quit"):
		get_tree().quit()
	if event.is_action_pressed("test_fullscreen"):
		OS.set_window_fullscreen(not OS.is_window_fullscreen())
	if Input.is_action_just_released("toggle_target_mode"):
		if mode == TargetMode.MOUSE:
			_set_target_mode_joypad()
		elif mode == TargetMode.JOYPAD:
			_set_target_mode_mouse()

func _set_target_mode_joypad():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	mode = TargetMode.JOYPAD

func _set_target_mode_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mode = TargetMode.MOUSE
