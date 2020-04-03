extends GroundMotionState


func enter():
	owner.get_node("CutoutAnim").play("move")
	.enter()


func update(delta):
	var input_direction = get_input_direction()
	if not input_direction:
		emit_signal("finished", "idle")
	
	var sector = owner.check_orientation_sector(input_direction.angle())
	owner.look_at_sector_w_anim(sector, "idle")
	move(input_direction)


func move(direction):
	var multiplier = 1
	
	if Input.is_action_pressed("sprint"):
		multiplier *= SPRINT_MULTIPLIER
	
	velocity = direction * MAX_SPEED * multiplier
	owner.move_and_slide(velocity)
