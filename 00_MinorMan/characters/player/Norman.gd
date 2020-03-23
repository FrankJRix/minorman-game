extends KinematicBody2D

const MAX_SPEED = 500
const SPRINT_MULTIPLIER = 1.5
const WEST_TRESHOLD = PI * 7/8
const SW_TRESHOLD = PI * 5/8
const SOUTH_TRESHOLD = PI * 3/8
const SE_TRESHOLD = PI * 1/8
const EAST_TRESHOLD = PI * -1/8
const NE_TRESHOLD = PI * -3/8
const NORTH_TRESHOLD = PI * -5/8
const NW_TRESHOLD = PI * -7/8
const EPSILON = 0.01

var speed = 0
var velocity = Vector2()
var direction = Vector2()
var multi = 1
var relative_mouse_angle = 0

func _physics_process(delta):
	move()

func move():
	get_input()
	manage_animation()

func get_input():
	multi = 1
	direction = Vector2()
	
	if Input.is_action_pressed("sprint"):
		multi *= SPRINT_MULTIPLIER
	
	if Input.is_action_pressed("move_north"):
		direction.y -= 1
	if Input.is_action_pressed("move_south"):
		direction.y += 1
	if Input.is_action_pressed("move_west"):
		direction.x -= 1
	if Input.is_action_pressed("move_east"):
		direction.x += 1
	
	direction = direction.normalized()
	
	velocity = direction * MAX_SPEED * multi
	move_and_slide(velocity)

func manage_animation():
	relative_mouse_angle = get_local_mouse_position().angle()
	
	if relative_mouse_angle >= WEST_TRESHOLD:
		$SpriteSheetAnim.play("idle_west")
	elif relative_mouse_angle >= SW_TRESHOLD:
		$SpriteSheetAnim.play("idle_sw")
	elif relative_mouse_angle >= SOUTH_TRESHOLD:
		$SpriteSheetAnim.play("idle_south")
	elif relative_mouse_angle >= SE_TRESHOLD:
		$SpriteSheetAnim.play("idle_se")
	elif relative_mouse_angle >= EAST_TRESHOLD:
		$SpriteSheetAnim.play("idle_east")
	elif relative_mouse_angle >= NE_TRESHOLD:
		$SpriteSheetAnim.play("idle_ne")
	elif relative_mouse_angle >= NORTH_TRESHOLD:
		$SpriteSheetAnim.play("idle_north")
	elif relative_mouse_angle >= NW_TRESHOLD:
		$SpriteSheetAnim.play("idle_nw")
	else:
		$SpriteSheetAnim.play("idle_west")
	
	if direction.length() > EPSILON:
		$CutoutAnim.play("move")
	else:
		$CutoutAnim.play("idle")






