extends Area2D
# TEST ONLY! Questo è un hack del cazzo messo insieme al volo, è lammerda!

func _ready():
	set_process_unhandled_input(false)


func _on_LadderDown_body_entered(body):
	if body.name == "Norman":
		set_process_unhandled_input(true)


func _on_LadderDown_body_exited(body):
	if body.name == "Norman":
		set_process_unhandled_input(false)


func _unhandled_input(event):
	if Input.is_action_just_pressed("interact"):
		get_tree().change_scene("res://classes/procedural_generation/ProceduralGeneration.tscn")
