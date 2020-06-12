extends MobMotionState

class_name MobAlertState

func enter():
	print("\nim alert bro.\n")
	emit_signal("finished", "idle")
