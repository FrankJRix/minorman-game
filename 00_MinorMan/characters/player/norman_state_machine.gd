extends StateMachine


func _ready():
	states_map = {
		"idle": $Idle,
		"move": $Move,
		"attack": $Attack,
		"die": $Die
	}


func _change_state(state_name):
	if not _active:
		return
	
	if state_name in ["stagger", "jump", "attack"]: # Reminder
		states_stack.push_front(states_map[state_name])
	
	if state_name == "attack":
		$Attack.initialize(current_state.speed, current_state.velocity)
	
	._change_state(state_name)


func _input(event):
	_debug_in() ###########


########## DEBUG
func _debug_in():
	pass
