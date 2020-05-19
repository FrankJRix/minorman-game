extends GroundMotionState


func enter():
	owner.get_node("CutoutAnim").play("idle")
	animate()
	.enter()


func update(delta):
	var input_direction = get_input_direction()
	animate()
	
	owner.move_with_knockback(Vector2())###########################################################
	
	if input_direction:
		emit_signal("finished", "move")


func animate():
	owner.look_at_w_anim(owner.get_target_position(), "idle")
