extends MobAlertState

func update(delta):
	var direction = (target.global_position - owner.global_position).normalized()
	
	owner.move_with_knockback(direction * MAX_SPEED)
	owner.look_at_w_anim(owner.last_facing_direction, "idle", 4)
