extends Health

func _ready():
	update_HUD()


func take_damage(amount, effect):
	.take_damage(amount, effect)
	update_HUD()


func heal(amount, effect):
	.heal(amount, effect)
	update_HUD()


func update_HUD():
	get_tree().call_group("HUD", "update_health", health)
