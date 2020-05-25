extends Area2D
# TEST ONLY! Questo è un hack del cazzo messo insieme al volo, è lammerda!

var norman: Entity

func _ready():
	set_process_unhandled_input(false)


func _on_LadderDown_body_entered(body):
	if body.name == "Norman":
		norman = body
		set_process_unhandled_input(true)


func _on_LadderDown_body_exited(body):
	if body.name == "Norman":
		set_process_unhandled_input(false)


func _unhandled_input(event):
	if Input.is_action_just_released("interact"):
		get_tree().call_group("Game", "set_active_scene", "res://classes/procedural_generation/ProceduralGeneration.tscn", norman)
