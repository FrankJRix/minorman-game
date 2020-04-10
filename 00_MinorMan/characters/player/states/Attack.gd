extends MotionState

const SLOWDOWN = 0.5


func initialize(o_speed, o_velocity):
	speed = o_speed
	velocity = o_velocity


func enter():
	animate()
	owner.get_node("HitTrail").swing_hit(owner.get_local_mouse_position())
	
	.enter()


func update(delta):
	var input_direction = get_input_direction()
	if input_direction:
		owner.get_node("CutoutAnim").play("move")
	else:
		owner.get_node("CutoutAnim").play("idle")
	move(input_direction)


func animate():
	owner.look_at_w_anim(owner.get_local_mouse_position(), "melee", owner.DIRECTION_MODE.FOUR)


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
