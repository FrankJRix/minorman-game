extends GroundMotionState


func enter():
	owner.get_node("CutoutAnim").play("move")
	.enter()


func update(delta):
	var input_direction = get_input_direction()
	if not input_direction:
		emit_signal("finished", "idle")
		return
	
	owner.look_at_w_anim(input_direction, "idle")
	move(input_direction)


func move(direction):
	var multiplier = 1
	
	if Input.is_action_pressed("sprint"):
		multiplier *= SPRINT_MULTIPLIER
	
	velocity = direction * MAX_SPEED * multiplier
	owner.move_with_knockback(velocity)
