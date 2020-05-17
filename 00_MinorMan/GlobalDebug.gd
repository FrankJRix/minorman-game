extends Node

enum TargetMode {MOUSE, JOYPAD}
var mode: int = TargetMode.MOUSE

func _input(event):
	if Input.is_action_just_released("quit"):
		get_tree().quit()
	if event.is_action_pressed("test_fullscreen"):
		OS.set_window_fullscreen(not OS.is_window_fullscreen())
	if Input.is_action_pressed("toggle_target_mode"):
		mode = (mode + 1) % 2
