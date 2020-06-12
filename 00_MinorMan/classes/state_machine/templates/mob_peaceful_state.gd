extends MobMotionState

class_name MobPeacefulState

func tick_update():
	if owner.hostility_conditions():
		emit_signal("finished", "alert")
