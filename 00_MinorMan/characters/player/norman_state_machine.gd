extends StateMachine


func _ready():
	states_map = {
		"idle": $Idle,
		"move": $Move,
		"attack": $Attack,
	}
