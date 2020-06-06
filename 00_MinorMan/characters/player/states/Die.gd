extends State

func enter():
	owner.get_node("CutoutAnim").play("idle")
	owner.look_at_w_anim(owner.get_local_mouse_position(), "die", owner.DIRECTION_MODE.TWO)
	
	################ PROVVISORIO
	var game_over = preload("res://classes/GUI/GameOver/GameOver.tscn").instance()
	get_tree().get_root().add_child(game_over)
	

func update(delta):
	owner.move_with_knockback(Vector2())
