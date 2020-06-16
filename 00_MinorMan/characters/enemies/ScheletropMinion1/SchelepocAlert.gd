extends MobAlertState

var counter: int
var old_target: Entity

func enter():
	counter = random_counter()
	old_target = target


func random_counter():
	return (4 + randi() % 4)


func tick_update():
	.tick_update()
	
	if target:
		owner.look_at_w_anim(target.position - owner.position, "idle", owner.DIRECTION_MODE.FOUR)
	
	if target == old_target:
		counter -= 1
	else:
		counter = random_counter()
	
	old_target = target
	
	if counter <= 0:
		emit_signal("finished", "chase")


func update(delta):
	owner.move_with_knockback(Vector2())
	.update(delta)
