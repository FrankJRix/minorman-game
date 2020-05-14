extends Area2D


func _on_HitBox_area_entered(area):
	if not area.owner:
		print(area.name, " non è una hitbox!")
		return
	if area.owner.has_method("take_damage"):
		area.owner.take_damage(self)


func _on_Tick_timeout():
	for area in get_overlapping_areas():
		if not area.owner:
			print(area.name, " non è una hitbox!")
		if area.owner.has_method("take_damage"):
			area.owner.take_damage(self)
