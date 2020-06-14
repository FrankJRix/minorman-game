extends MobMotionState

class_name MobAlertState

func enter():
	pass

func tick_update():
	var target: Entity = owner.acquire_target()
	if target:
		owner.look_at_w_anim(target.position - owner.position, "idle", owner.DIRECTION_MODE.FOUR)
	else:
		emit_signal("finished", "idle")
	.tick_update()
