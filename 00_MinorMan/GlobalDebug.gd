extends Node

enum TargetMode {MOUSE, JOYPAD}
var mode = TargetMode.JOYPAD


func do_debug():
	print(get_tree().get_nodes_in_group("active_entities"))


func _ready():
	if Input.get_connected_joypads() or OS.get_name() == "Android":
		_set_target_mode_joypad()
	else:
		_set_target_mode_mouse()


func show_touch_joypad():
	var touch_pad = load("res://classes/GUI/TouchStick/TouchJoypad.tscn").instance()
	get_tree().get_root().call_deferred("add_child", touch_pad)


func _input(event):
	if Input.is_action_just_released("quit"):
		get_tree().quit()
	
	if event.is_action_pressed("test_fullscreen"):
		OS.window_fullscreen = not OS.is_window_fullscreen()
	
	if Input.is_action_just_released("toggle_target_mode"):
		if mode == TargetMode.MOUSE:
			_set_target_mode_joypad()
		elif mode == TargetMode.JOYPAD:
			_set_target_mode_mouse()
	
	if Input.is_action_just_released("test_input"):
		do_debug()

func _set_target_mode_joypad():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	mode = TargetMode.JOYPAD

func _set_target_mode_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mode = TargetMode.MOUSE
