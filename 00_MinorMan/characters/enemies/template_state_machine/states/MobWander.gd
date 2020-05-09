extends MobPeacefulState

var steps: int = 1
var step_angle: float = 0
var step_length: float = 200
var step_direction: Vector2 = Vector2.RIGHT

func enter():
	owner.get_node("SpriteSheetAnim").play("leap_left")
	steps += randi() % 5
	decide_direction()
	.enter()


func decide_direction():
	step_angle = rand_range(-PI, PI)
	step_length = rand_range(150, 350)
	step_direction = Vector2(cos(step_angle), sin(step_angle))


func update(delta):
	move()


func move():
	velocity = step_direction * step_length
	owner.move_and_slide(velocity)


func _on_animation_finished(anim_name):
	owner.get_node("SpriteSheetAnim").play("leap_left")
	steps -= 1
	
	if steps <= 0:
		emit_signal("finished", "idle")
		return
	
	decide_direction()
