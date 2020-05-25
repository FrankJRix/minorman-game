extends Control


func _on_loading_finished():
	$CanvasLayer/CenterContainer.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_Button_pressed():
	get_tree().change_scene("res://levels/TemplateLevel.tscn")


func _ready():
	$TitleBGCinematic.set_process_input(false)
	$TitleBGCinematic/YSort/Norman/StateMachine.queue_free()
	$TitleBGCinematic/YSort/Norman/HUD.queue_free()
