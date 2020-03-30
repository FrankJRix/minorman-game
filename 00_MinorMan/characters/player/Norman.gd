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

enum MOUSE_SECTOR {WEST, SOUTHWEST, SOUTH, SOUTHEAST, EAST, NORTHEAST, NORTH, NORTHWEST}

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
	
	match check_mouse_sector(relative_mouse_angle):
		MOUSE_SECTOR.WEST:
			$SpriteSheetAnim.play("idle_west")
		MOUSE_SECTOR.SOUTHWEST:
			$SpriteSheetAnim.play("idle_sw")
		MOUSE_SECTOR.SOUTH:
			$SpriteSheetAnim.play("idle_south")
		MOUSE_SECTOR.SOUTHEAST:
			$SpriteSheetAnim.play("idle_se")
		MOUSE_SECTOR.EAST:
			$SpriteSheetAnim.play("idle_east")
		MOUSE_SECTOR.NORTHEAST:
			$SpriteSheetAnim.play("idle_ne")
		MOUSE_SECTOR.NORTH:
			$SpriteSheetAnim.play("idle_north")
		MOUSE_SECTOR.NORTHWEST:
			$SpriteSheetAnim.play("idle_nw")
	
	if direction.length() > EPSILON:
		$CutoutAnim.play("move")
	else:
		$CutoutAnim.play("idle")


func check_mouse_sector(mouse_angle):
	var sector
	
	if relative_mouse_angle >= WEST_TRESHOLD:
		sector = MOUSE_SECTOR.WEST
	elif relative_mouse_angle >= SW_TRESHOLD:
		sector = MOUSE_SECTOR.SOUTHWEST
	elif relative_mouse_angle >= SOUTH_TRESHOLD:
		sector = MOUSE_SECTOR.SOUTH
	elif relative_mouse_angle >= SE_TRESHOLD:
		sector = MOUSE_SECTOR.SOUTHEAST
	elif relative_mouse_angle >= EAST_TRESHOLD:
		sector = MOUSE_SECTOR.EAST
	elif relative_mouse_angle >= NE_TRESHOLD:
		sector = MOUSE_SECTOR.NORTHEAST
	elif relative_mouse_angle >= NORTH_TRESHOLD:
		sector = MOUSE_SECTOR.NORTH
	elif relative_mouse_angle >= NW_TRESHOLD:
		sector = MOUSE_SECTOR.NORTHWEST
	else:
		sector = MOUSE_SECTOR.WEST
	
	return sector


func _unhandled_input(event):
	if event.is_action_pressed("attack"):
		$HitTrail/AnimationPlayer.stop()
		$HitTrail.rotation = relative_mouse_angle - PI / 2
		$HitTrail/AnimationPlayer.play("hit")
