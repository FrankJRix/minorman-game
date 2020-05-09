extends StateMachine

class_name EntityStateMachine


func _ready():
	map_available_states()


func map_available_states(): # overridable
	states_map = {
		"idle": $Idle
	}
