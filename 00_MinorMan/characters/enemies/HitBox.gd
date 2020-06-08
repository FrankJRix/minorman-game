extends Area2D

const KNOCKBACK_VALUE = 2500

export var display_name: String = "weapon_template"
export var base_damage: int = 1
export (float, 0.0, 5.0) var base_knockback: float = 1.0
export var effect_list: Array = []

func _on_HitBox_area_entered(area):
	if not area.owner:
		print(area.name, " non è una hitbox!")
		return
	if area.owner.has_method("take_damage"):
		area.owner.take_damage(self, base_damage, base_knockback * KNOCKBACK_VALUE, effect_list)


func _tick_update():
	for area in get_overlapping_areas():
		if not area.owner:
			print(area.name, " non è una hitbox!")
			return
		if area.owner.has_method("take_damage"):
			area.owner.take_damage(self, base_damage, base_knockback * KNOCKBACK_VALUE, effect_list)
