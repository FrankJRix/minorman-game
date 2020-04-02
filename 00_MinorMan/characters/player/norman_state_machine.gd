extends StateMachine


func _ready():
	states_map = {
		"idle": $Idle,
		"move": $Move,
		"attack": $Attack,
	}

func _change_state(state_name):
	if not _active:
		return
	# Useless at present.
	# Add exceptions, initializations and stack management here if the need arires. Else, delete. 
	._change_state(state_name)
