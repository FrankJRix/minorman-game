extends MotionState

const SLOWDOWN = 0.5

func initialize(o_speed, o_velocity):
	speed = o_speed
	velocity = o_velocity


func enter():
	attack(owner.get_target_position())
	.enter()


func update(delta):
	var input_direction = get_input_direction()
	if input_direction:
		owner.get_node("CutoutAnim").play("move")
	else:
		owner.get_node("CutoutAnim").play("idle")
	move(input_direction)


func attack(direction):
	owner.look_at_w_anim(direction, "melee", owner.DIRECTION_MODE.FOUR)
	get_owner_current_weapon().swing_hit(direction)


func move(direction):
	var multiplier = 1
	
	if Input.is_action_pressed("sprint"):
		multiplier *= SPRINT_MULTIPLIER
	
	velocity = direction * MAX_SPEED * multiplier * get_owner_current_weapon().slowdown
	owner.move_with_knockback(velocity)


func handle_input(event):
	if event.is_action_pressed("attack") and get_owner_current_weapon().can_swing:
		owner.get_node("SpriteSheetAnim").stop()
		enter()


func _on_animation_finished(anim_name):
	emit_signal("finished", "previous")


func get_owner_current_weapon():
	return owner.get_equipped_weapon()
