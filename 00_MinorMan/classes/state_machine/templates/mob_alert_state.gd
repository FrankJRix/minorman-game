extends MobMotionState

class_name MobAlertState

var target: Entity

func initialize(o_target):
	target = o_target


func get_target():
	return target


func tick_update():
	target = owner.acquire_target()
	
	if not target:
		emit_signal("finished", "idle")
	.tick_update()
