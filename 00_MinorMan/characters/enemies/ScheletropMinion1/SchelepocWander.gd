extends MobPeacefulState

var steps: int = 1
var step_angle: float = 0
var step_length: float = 200
var step_direction: Vector2 = Vector2.RIGHT

func enter():
	steps += randi() % 5
	decide_direction()
	.enter()


func decide_direction():
	step_angle = rand_range(-PI, PI)
	step_length = rand_range(150, 200)
	step_direction = Vector2(cos(step_angle), sin(step_angle))
	owner.look_at_w_anim(step_direction, "float", 4)


func modify_direction():
	step_angle = rand_range(step_angle - PI/6, step_angle + PI/6)
	step_length = rand_range(180, 250)
	step_direction = Vector2(cos(step_angle), sin(step_angle))
	owner.look_at_w_anim(step_direction, "float", 4)


func update(delta):
	owner.sight_ray.cast_to = step_direction * 128
	owner.sight_ray.force_raycast_update()
	
	if owner.sight_ray.is_colliding():
		decide_direction()
	
	move()


func move():
	velocity = step_direction * step_length
	owner.move_with_knockback(velocity)


func _on_animation_finished(anim_name):
	steps -= 1
	
	if steps <= 0:
		emit_signal("finished", "idle")
		return
	
	modify_direction()
