extends MotionState

const SLOWDOWN = 0.5

var mouse_sector
var relative_mouse_angle


func initialize(o_speed, o_velocity):
	speed = o_speed
	velocity = o_velocity


func enter():
	relative_mouse_angle = owner.get_local_mouse_position().angle()
	mouse_sector = owner.check_orientation_sector(relative_mouse_angle)
	owner.look_at_sector_w_anim(mouse_sector, "melee", owner.DIRECTION_MODE.FOUR)
	
	# Put this in a damn function. Piazzajela.
	owner.get_node("HitTrail/AnimationPlayer").stop()
	owner.get_node("HitTrail").rotation = relative_mouse_angle - PI / 2
	owner.get_node("HitTrail/AnimationPlayer").play("hit")
	
	.enter()


func update(delta):
	var input_direction = get_input_direction()
	if input_direction:
		owner.get_node("CutoutAnim").play("move")
	else:
		owner.get_node("CutoutAnim").play("idle")
	move(input_direction)


func move(direction):
	var multiplier = 1
	
	if Input.is_action_pressed("sprint"):
		multiplier *= SPRINT_MULTIPLIER
	
	velocity = direction * MAX_SPEED * multiplier * SLOWDOWN
	owner.move_and_slide(velocity)


func handle_input(event):
	if event.is_action_pressed("attack"):
		owner.get_node("SpriteSheetAnim").stop()
		enter()


func _on_animation_finished(anim_name):
	emit_signal("finished", "previous")
