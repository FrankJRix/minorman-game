extends MobPeacefulState

var wait_counter: int = 2

func enter():
	owner.get_node("SpriteSheetAnim").play("idle_left")
	randomize()
	wait_counter = 2 + (randi() % 11)
	.enter()

func tick_update():
	wait_counter -= 1
	if wait_counter == 0:
		emit_signal("finished", "wander")
