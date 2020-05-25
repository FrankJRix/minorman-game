extends Node

var inactive_scenes_stack := []
var previous_norman_positions_stack := []


func set_active_scene(path: String, norman: Entity = null, reversible: bool = false):
	var new_scene: Location = load(path).instance()
	
	if $ActiveSceneSlot.get_child(0):
		var previous_scene := $ActiveSceneSlot.get_child(0)
		
		previous_scene.remove_child(norman)
		
		if reversible:
			$ActiveSceneSlot.remove_child(previous_scene)
			inactive_scenes_stack.push_back(previous_scene)
		else:
			previous_scene.queue_free()
	
	new_scene.norman_slot.add_child(norman)
	
	$ActiveSceneSlot.add_child(new_scene)


func go_to_previous_scene(norman: Entity = null):
	# Qui codice per prelevare Norman dalla vecchia scena
	
	$ActiveSceneSlot.remove_child($ActiveSceneSlot.get_child(0))
	$ActiveSceneSlot.add_child(inactive_scenes_stack.pop_back())
	
	# Qui codice per piazzare Norman nella scena nuova
