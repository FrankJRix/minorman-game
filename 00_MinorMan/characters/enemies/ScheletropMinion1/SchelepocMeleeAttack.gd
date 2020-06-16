extends MobAlertState

func enter():
	var relative_target_position: Vector2 = target.global_position - owner.global_position
	attack(relative_target_position)


func attack(direction):
	owner.look_at_w_anim(direction, "melee", owner.DIRECTION_MODE.FOUR, true)
	owner.get_node("ActionAnim").play("melee_attack")


func update(delta):
	owner.move_with_knockback(Vector2())
	.update(delta)


func _on_animation_finished(anim_name):
	emit_signal("finished", "alert") 


func get_owner_current_weapon():
	return owner.get_equipped_weapon()
