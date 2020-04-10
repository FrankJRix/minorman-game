extends Entity

const MAX_SPEED = 500
const SPRINT_MULTIPLIER = 1.5

const CROSSHAIR_DISTANCE = 200
const CROSSHAIR_SMOOTHING = 0.2

const CAMERA_DISTANCE = 300
const CAMERA_TRESHOLD = 290
const CAMERA_SMOOTHING = 0.02
const CAMERA_RESET_SMOOTHING = 0.03

onready var crosshair = $Crosshair
onready var camera = $Camera2D


func _process(delta):
	move_crosshair()
	move_camera()


func move_crosshair():
	var new_position = get_local_mouse_position().clamped(CROSSHAIR_DISTANCE)
	crosshair.position = crosshair.position.linear_interpolate(new_position, CROSSHAIR_SMOOTHING)


func move_camera():
	var new_position = get_local_mouse_position().clamped(CAMERA_DISTANCE)
	if new_position.length() > CAMERA_TRESHOLD:
		camera.position = camera.position.linear_interpolate(new_position, CAMERA_SMOOTHING)
	else:
		camera.position = camera.position.linear_interpolate(Vector2.ZERO, CAMERA_RESET_SMOOTHING)


func _on_Tick_timeout():
	get_tree().call_group("GUI", "update_player_marker", position)
