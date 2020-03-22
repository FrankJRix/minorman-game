extends KinematicBody2D

const MAX_SPEED = 500
const SPRINT_MULTIPLIER = 1.5

var speed = 0
var velocity = Vector2()
var direction = Vector2()
var multi = 1

func _physics_process(delta):
	move()

func move():
	get_input()

func get_input():
	multi = 1
	direction = Vector2()
	
	if Input.is_action_pressed("sprint"):
		multi *= SPRINT_MULTIPLIER
	
	if Input.is_action_pressed("move_north"):
		direction.y -= 1
		$AnimationPlayer.play("idle_north")
	if Input.is_action_pressed("move_south"):
		direction.y += 1
		$AnimationPlayer.play("idle_south")
	if Input.is_action_pressed("move_west"):
		direction.x -= 1
		$AnimationPlayer.play("idle_west")
	if Input.is_action_pressed("move_east"):
		direction.x += 1
		$AnimationPlayer.play("idle_east")
	
	direction = direction.normalized()
	
	velocity = direction * MAX_SPEED * multi
	move_and_slide(velocity)
