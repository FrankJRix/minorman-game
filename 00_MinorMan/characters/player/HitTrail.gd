extends Sprite

# estendere includendo danno?

func _on_Area2D_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(self)
