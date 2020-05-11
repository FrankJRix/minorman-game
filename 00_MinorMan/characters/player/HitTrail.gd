extends Sprite

# estendere includendo danno?

func _on_Area2D_area_entered(area):
	if not area.owner:
		print(area.name, " non è una hitbox!")
		return
	if area.owner.has_method("take_damage"):
		area.owner.take_damage(self)


func swing_hit(direction):
	$AnimationPlayer.stop()
	rotation = direction.angle() - PI / 2
	$AnimationPlayer.play("hit")


func _on_Area2D_body_entered(body):
	if body is TileMap and body.has_method("take_damage"):
		body.take_damage(self)
