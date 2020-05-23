extends Sprite

const WEST_TRESHOLD = PI * 7/8
const SW_TRESHOLD = PI * 5/8
const SOUTH_TRESHOLD = PI * 3/8
const SE_TRESHOLD = PI * 1/8
const EAST_TRESHOLD = PI * -1/8
const NE_TRESHOLD = PI * -3/8
const NORTH_TRESHOLD = PI * -5/8
const NW_TRESHOLD = PI * -7/8

var active := false
var angle: float

# Da mostrare solo su mobile

func _input(event):
	var action1 = InputEventAction.new()
	var action2 = InputEventAction.new()
	
	if event is InputEventScreenTouch:
		active = event.pressed
	
	if not active:
		position = Vector2()
		Input.action_release("move_north")
		Input.action_release("move_south")
		Input.action_release("move_west")
		Input.action_release("move_east")
	
	if event is InputEventScreenDrag:
		if active:
			position = ((event.position - get_parent().global_position) / get_parent().scale).clamped(30)
		
		angle = position.angle()
		
		if position.length() > 15:
			if angle >= WEST_TRESHOLD:
				Input.action_release("move_north")
				Input.action_release("move_south")
				Input.action_release("move_east")
				Input.action_press("move_west")
			elif angle >= SW_TRESHOLD:
				Input.action_release("move_north")
				Input.action_release("move_east")
				Input.action_press("move_south")
				Input.action_press("move_west")
			elif angle >= SOUTH_TRESHOLD:
				Input.action_release("move_north")
				Input.action_release("move_west")
				Input.action_release("move_east")
				Input.action_press("move_south")
			elif angle >= SE_TRESHOLD:
				Input.action_release("move_north")
				Input.action_release("move_west")
				Input.action_press("move_south")
				Input.action_press("move_east")
			elif angle >= EAST_TRESHOLD:
				Input.action_release("move_north")
				Input.action_release("move_south")
				Input.action_release("move_west")
				Input.action_press("move_east")
			elif angle >= NE_TRESHOLD:
				Input.action_release("move_west")
				Input.action_release("move_south")
				Input.action_press("move_north")
				Input.action_press("move_east")
			elif angle >= NORTH_TRESHOLD:
				Input.action_release("move_west")
				Input.action_release("move_south")
				Input.action_release("move_east")
				Input.action_press("move_north")
			elif angle >= NW_TRESHOLD:
				Input.action_release("move_south")
				Input.action_release("move_east")
				Input.action_press("move_north")
				Input.action_press("move_west")
			else:
				Input.action_release("move_north")
				Input.action_release("move_south")
				Input.action_release("move_east")
				Input.action_press("move_west")
		else:
			Input.action_release("move_north")
			Input.action_release("move_south")
			Input.action_release("move_west")
			Input.action_release("move_east")
	
