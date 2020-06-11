extends VisibilityEnabler2D


func _on_VisibilityEnabler2D_screen_entered():
	set_owner_status(true)


func _on_VisibilityEnabler2D_screen_exited():
	set_owner_status(false)


func set_owner_status(value: bool):
	if not owner:
		return
	
	if value:
		owner.add_to_group("active_entities")
	else:
		owner.remove_from_group("active_entities")
	
	set_node_status(owner.get_node("StateMachine"), value)
	owner.get_node("Tick").paused = not value


func set_node_status(node: Node, value: bool):
	node.set_physics_process(value)
	node.set_process(value)
