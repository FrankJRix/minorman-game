extends Sprite

# estendere includendo danno?

func _on_Area2D_area_entered(area):
	if area.owner.has_method("take_damage"):
		area.owner.take_damage(self)


func swing_hit(direction):
	$AnimationPlayer.stop()
	rotation = direction.angle() - PI / 2
	$AnimationPlayer.play("hit")
