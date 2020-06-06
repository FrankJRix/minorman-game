extends MotionState

class_name GroundMotionState

func handle_input(event):
	if event.is_action_pressed("attack") and owner.get_equipped_weapon().can_swing:
		emit_signal("finished", "attack")
	# Reminder.
	if event.is_action_pressed("jump"):
		emit_signal("finished", "jump")
	return .handle_input(event)
