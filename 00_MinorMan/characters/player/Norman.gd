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

var weapon_slot_nodepath: NodePath = "CenterPivot/WeaponSlot"
var equipped_weapon_index := 0 # Da aggiornare una volta implementati gli slot armi multipli!

func _ready():
	connect("hide_crosshair", crosshair, "hide")
	connect("show_crosshair", crosshair, "show")
	
	add_to_group("active_entities")


func _process(delta):
	move_crosshair()
	move_camera()


func take_damage(attacker: Node, amount: int, knockback: int, effect_list: Array):
	if self.is_a_parent_of(attacker) or not $Health.alive or damage_cooldown:
		return
	
	damage_cooldown = 6
	$ModulationAnim.stop()
	$ModulationAnim.play("hit")
	get_tree().call_group("GFX", "hurt")
	
	.take_damage(attacker, amount, knockback, effect_list)

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


func get_equipped_weapon():
	return get_node(weapon_slot_nodepath).get_child(equipped_weapon_index)


func _tick_update():
	get_tree().call_group("GUI", "update_player_marker", position)
	if damage_cooldown:
		damage_cooldown = clamp(damage_cooldown - 1, 0, INF)


func add_to_appropriate_faction():
	add_to_group(Data.factions["player"])


func die():
	set_dead(true)
	remove_from_group("active_entities")
	$StateMachine._change_state("die")


func set_dead(value):
	set_process_input(not value)
	$CenterPivot/Hitbox/CollisionShape2D.set_deferred("disabled", value)
