extends MobStateMachine

func map_available_states():
	states_map = {
		"idle": $Idle,
		"wander": $Wander,
		"alert": $Alert,
		"chase": $Chase,
		"attack": $Attack
	}


func _change_state(state_name):
	if not _active:
		return
	
	if state_name in ["alert" ,"chase", "attack"] and current_state.has_method("get_target"):
		states_map[state_name].initialize(current_state.get_target())
	
	._change_state(state_name)
