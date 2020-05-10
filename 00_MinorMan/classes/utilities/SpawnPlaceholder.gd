extends VisibilityNotifier2D

var spawn_target: Resource = null

func _on_SpawnPlaceholder_screen_entered():
	var entity = spawn_target.instance()
	entity.position = position
	get_parent().add_child(entity, true)
	queue_free()
