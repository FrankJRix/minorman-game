extends MobAlertState

func update(delta):
	var relative_target_position: Vector2 = target.global_position - owner.global_position
	var direction: Vector2 = (relative_target_position).normalized()
	
	owner.move_with_knockback(direction * MAX_SPEED)
	owner.look_at_w_anim(owner.last_facing_direction, "idle", 4)
	
	if relative_target_position.length() <= owner.radius:
		emit_signal("finished", "attack")
