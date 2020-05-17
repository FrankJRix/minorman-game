extends Entity

const MAX_SPEED = 500
const SPRINT_MULTIPLIER = 2

const CROSSHAIR_DISTANCE = 200
const CROSSHAIR_SMOOTHING = 0.2

const CAMERA_DISTANCE = 300
const CAMERA_TRESHOLD = 290
const CAMERA_SMOOTHING = 0.02
const CAMERA_RESET_SMOOTHING = 0.03

onready var crosshair := $CenterPivot/Crosshair
onready var camera := $CenterPivot/Camera2D

var damage_cooldown := 0
var melee_cooldown := 0

func _process(delta):
	move_crosshair()
	move_camera()


func take_damage(attacker, amount=1, effect=null):
	if self.is_a_parent_of(attacker) or not $Health.alive or damage_cooldown:
		return
	
	damage_cooldown = 6
	$ModulationAnim.stop()
	$ModulationAnim.play("hit")
	
	.take_damage(attacker, amount, effect)


func move_crosshair():
	var new_position = (get_target_position() - $CenterPivot.position).clamped(CROSSHAIR_DISTANCE)
	crosshair.position = crosshair.position.linear_interpolate(new_position, CROSSHAIR_SMOOTHING)


func move_camera():
	var new_position = (get_target_position() - $CenterPivot.position).clamped(CAMERA_DISTANCE)
	if new_position.length() > CAMERA_TRESHOLD:
		camera.position = camera.position.linear_interpolate(new_position, CAMERA_SMOOTHING)
	else:
		camera.position = camera.position.linear_interpolate(Vector2.ZERO, CAMERA_RESET_SMOOTHING)


func get_target_position():
	var mouse_target = get_local_mouse_position()
	var joypad_target = Vector2(Input.get_joy_axis(0, 2), Input.get_joy_axis(0, 3)) * 300
	
	match GlobalDebug.mode:
		
		GlobalDebug.TargetMode.MOUSE:
			return mouse_target
		
		GlobalDebug.TargetMode.JOYPAD:
			if joypad_target.length() > 30:
				crosshair.show()
				return joypad_target + $CenterPivot.position
			else:
				crosshair.hide()
				return Vector2()


func _on_Tick_timeout():
	get_tree().call_group("GUI", "update_player_marker", position)
	if damage_cooldown:
		damage_cooldown = clamp(damage_cooldown - 1, 0, INF)
	if melee_cooldown:
		melee_cooldown = clamp(melee_cooldown - 1, 0, INF)


func die():
	set_dead(true)
	$StateMachine._change_state("die")
