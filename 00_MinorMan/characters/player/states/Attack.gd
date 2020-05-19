extends MotionState

const SLOWDOWN = 0.5
const ATTACK_COOLDOWN = 2

func initialize(o_speed, o_velocity):
	speed = o_speed
	velocity = o_velocity


func enter():
	attack(owner.get_target_position())
	
	owner.melee_cooldown = ATTACK_COOLDOWN
	
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
	owner.get_node("CenterPivot/HitTrail").swing_hit(direction)


func move(direction):
	var multiplier = 1
	
	if Input.is_action_pressed("sprint"):
		multiplier *= SPRINT_MULTIPLIER
	
	velocity = direction * MAX_SPEED * multiplier * SLOWDOWN
	owner.move_with_knockback(velocity)


func handle_input(event):
	if event.is_action_pressed("attack") and not owner.melee_cooldown:
		owner.get_node("SpriteSheetAnim").stop()
		enter()


func _on_animation_finished(anim_name):
	emit_signal("finished", "previous")
