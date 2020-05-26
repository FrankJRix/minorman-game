extends Area2D
# TEST ONLY! Questo è un hack del cazzo messo insieme al volo, è lammerda!

var norman: Entity
export var leading_to: String = "res://classes/procedural_generation/ProceduralGeneration.tscn"
export var reversible: bool = false
export var going_back: bool = false

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
		_lead_to_path()


func _lead_to_path():
	if going_back:
		get_tree().call_group("Game", "go_to_previous_scene", norman)
	else:
		get_tree().call_group("Game", "set_active_scene", leading_to, norman, reversible)
