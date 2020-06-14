extends MobPeacefulState

var wait_counter: int = 2

func enter():
	randomize()
	
	owner.look_at_w_anim(owner.last_facing_direction, "idle", 4)
	wait_counter = 2 + (randi() % 11)
	.enter()


func update(delta):
	owner.move_with_knockback(Vector2())


func tick_update():
	.tick_update()
	wait_counter -= 1
	if wait_counter == 0:
		emit_signal("finished", "wander")
