extends Control


func _on_loading_finished():
	$CanvasLayer/CenterContainer.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_Button_pressed():
	var game_scene = load("res://classes/utilities/GameManager/GameManager.tscn").instance()
	game_scene.set_active_scene("res://levels/TemplateLevel.tscn")
	if GlobalDebug.mode == GlobalDebug.TargetMode.JOYPAD:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	get_tree().get_root().add_child(game_scene)
	queue_free()


func _ready():
	$TitleBGCinematic.set_process_input(false)
	$TitleBGCinematic/YSort/Norman/StateMachine.queue_free()
	$TitleBGCinematic/YSort/Norman/HUD.queue_free()
	$TitleBGCinematic/YSort/Norman/Health.max_health = INF
	$TitleBGCinematic/YSort/Norman/Health.health = INF
	
	$CanvasLayer/CenterContainer/VBoxContainer/CenterContainer/Button.grab_focus()
