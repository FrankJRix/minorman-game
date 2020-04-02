extends State

class_name MotionState

# This takes input.
func get_input_direction():
	var input_direction = Vector2()
	input_direction.x = int(Input.is_action_pressed("move_east")) - int(Input.is_action_pressed("move_west"))
	input_direction.y = int(Input.is_action_pressed("move_south")) - int(Input.is_action_pressed("move_north"))
	return input_direction.normalized()

