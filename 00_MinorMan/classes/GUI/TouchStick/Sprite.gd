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


func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		_handle_touch(event)


func _handle_touch(event):
	if event is InputEventScreenTouch:
		active = event.pressed
	
	if ((event.position - get_parent().global_position) / get_parent().scale).length() > 60:
		active = false
	
	if not active:
		_reset()
	
	if event is InputEventScreenDrag:
		if active:
			position = ((event.position - get_parent().global_position) / get_parent().scale).clamped(30)
		
		angle = position.angle()
		
		if position.length() > 10:
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


func _reset():
	position = Vector2()
	Input.action_release("move_north")
	Input.action_release("move_south")
	Input.action_release("move_west")
	Input.action_release("move_east")
