extends MobPeacefulState

func tick_update():
	var target: Entity = owner.acquire_target()
	if target:
		owner.look_at_w_anim(target.position - owner.position, "idle", owner.DIRECTION_MODE.FOUR)
	
	.tick_update()
