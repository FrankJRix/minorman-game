extends Node

func _input(event):
	if Input.is_action_just_released("ui_cancel"):
		get_tree().quit()
	if event.is_action_pressed("test_fullscreen"):
		OS.set_window_fullscreen(not OS.is_window_fullscreen())
