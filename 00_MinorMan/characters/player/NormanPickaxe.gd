extends MeleeWeapon


func _on_Area2D_body_entered(body):
	if body is TileMap and body.has_method("take_damage"):
		body.take_damage(self)

