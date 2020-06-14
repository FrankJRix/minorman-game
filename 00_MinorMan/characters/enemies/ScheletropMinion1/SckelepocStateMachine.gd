extends MobStateMachine

func map_available_states():
	states_map = {
		"idle": $Idle,
		"wander": $Wander,
		"alert": $Alert
	}
