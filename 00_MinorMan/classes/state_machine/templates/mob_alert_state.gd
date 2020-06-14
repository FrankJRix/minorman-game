extends MobMotionState

class_name MobAlertState


func tick_update():
	var target: Entity = owner.acquire_target()
	if target:
		owner.look_at_w_anim(target.position - owner.position, "idle", owner.DIRECTION_MODE.FOUR)
	else:
		emit_signal("finished", "idle")
	.tick_update()


func update(delta):
	owner.move_with_knockback(Vector2())
	.update(delta)
