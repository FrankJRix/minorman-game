extends Entity

const MAX_SPEED = 500
const SPRINT_MULTIPLIER = 2

const CROSSHAIR_DISTANCE = 200
const CROSSHAIR_SMOOTHING = 0.2

const CAMERA_DISTANCE = 400
const CAMERA_TRESHOLD = 290
const CAMERA_SMOOTHING = 0.005
const CAMERA_RESET_SMOOTHING = 0.01

const JOYPAD_SENSITIVITY = 0.2

onready var center := $CenterPivot
onready var crosshair := $CenterPivot/Crosshair
onready var camera := $CenterPivot/Camera2D

signal show_crosshair
signal hide_crosshair

var damage_cooldown := 0
var melee_cooldown := 0

func _ready():
	connect("hide_crosshair", crosshair, "hide")
	connect("show_crosshair", crosshair, "show")
	
	
	print("============================================================================Stanno resettando " + name)


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

# da migliorare
func move_crosshair():
	var new_position = get_target_position().clamped(CROSSHAIR_DISTANCE)
	crosshair.position = crosshair.position.linear_interpolate(new_position, CROSSHAIR_SMOOTHING)

# da migliorare
func move_camera():
	var new_position = get_target_position().clamped(CAMERA_DISTANCE)
	if new_position.length() > CAMERA_TRESHOLD:
		camera.position = camera.position.linear_interpolate(new_position, CAMERA_SMOOTHING)
	else:
		camera.position = camera.position.linear_interpolate(Vector2.ZERO, CAMERA_RESET_SMOOTHING)
# serve una funzione che prende la direzione e la manipola a seconda dello schema di comandi

func get_target_position():
	
	match GlobalDebug.mode:
		
		GlobalDebug.TargetMode.MOUSE:
			emit_signal("show_crosshair")
			return get_local_mouse_position() - center.position
		
		GlobalDebug.TargetMode.JOYPAD:
			var joypad_target = Vector2(Input.get_joy_axis(0, 2), Input.get_joy_axis(0, 3))
			
			if joypad_target.length() > JOYPAD_SENSITIVITY:
				emit_signal("show_crosshair")
				
				last_facing_direction = joypad_target
			else:
				emit_signal("hide_crosshair")
			
			return last_facing_direction * CAMERA_DISTANCE


func _tick_update():
	get_tree().call_group("GUI", "update_player_marker", position)
	if damage_cooldown:
		damage_cooldown = clamp(damage_cooldown - 1, 0, INF)
	if melee_cooldown:
		melee_cooldown = clamp(melee_cooldown - 1, 0, INF)


func die():
	set_dead(true)
	$StateMachine._change_state("die")
