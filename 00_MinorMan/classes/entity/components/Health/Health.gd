extends Node

class_name Health

signal damaged(amount)
signal healed(amount)
signal health_depleted

export var max_health := 6
var health: int

func _ready():
	health = max_health

func take_damage(amount, effect):
	health = clamp(health - amount, 0, max_health)
	
	emit_signal("damaged", amount)
	
	if health == 0:
		emit_signal("health_depleted")


func heal(amount, effect):
	health = clamp(health + amount, 0, max_health)
	
	emit_signal("healed", amount)
