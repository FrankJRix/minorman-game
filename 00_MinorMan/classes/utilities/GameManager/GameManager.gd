extends Node

const NORMAN_PATH = "res://characters/player/Norman.tscn"

var inactive_scenes_stack := []
var previous_norman_positions_stack := []


func _ready():
	add_to_group("Game")


func set_active_scene(path: String, norman: Entity = null, reversible: bool = false):
	var new_scene: Location = load(path).instance()
	
	if $ActiveSceneSlot.get_child_count():
		var previous_scene := $ActiveSceneSlot.get_child(0)
		
		previous_scene.get_node(previous_scene.norman_slot).remove_child(norman)
		
		if reversible:
			$ActiveSceneSlot.remove_child(previous_scene)
			inactive_scenes_stack.push_back(previous_scene)
			previous_norman_positions_stack.push_back(norman.position)
		else:
			previous_scene.queue_free()
	
	if not norman:
		norman = load(NORMAN_PATH).instance()
	
	new_scene.get_node(new_scene.norman_slot).add_child(norman)
	
	$ActiveSceneSlot.add_child(new_scene)


func go_to_previous_scene(norman: Entity = null):
	var new_scene: Location = inactive_scenes_stack.pop_back()
	var previous_scene := $ActiveSceneSlot.get_child(0)
	
	previous_scene.remove_child(norman)
	
	previous_scene.queue_free()
	
	new_scene.get_node(new_scene.norman_slot).add_child(norman)
	norman.position = previous_norman_positions_stack.pop_back()
	
	$ActiveSceneSlot.add_child(new_scene)
	
