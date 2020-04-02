extends GroundMotionState

var mouse_sector
var relative_mouse_angle


func enter():
	owner.get_node("CutoutAnim").play("idle")
	relative_mouse_angle = owner.get_local_mouse_position().angle()
	mouse_sector = owner.check_orientation_sector(relative_mouse_angle)
	owner.look_at_sector_w_anim(mouse_sector, "idle")
	
	.enter()


func update(delta):
	var input_direction = get_input_direction()
	relative_mouse_angle = owner.get_local_mouse_position().angle()
	mouse_sector = owner.check_orientation_sector(relative_mouse_angle)
	owner.look_at_sector_w_anim(mouse_sector, "idle")
	
	if input_direction:
		emit_signal("finished", "move")
