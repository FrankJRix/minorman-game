extends Health

func _ready():
	update_provv_meter()


func take_damage(amount, effect):
	.take_damage(amount, effect)
	update_provv_meter()


func heal(amount, effect):
	.heal(amount, effect)
	update_provv_meter()


# PROVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
func update_provv_meter():
	owner.get_node("ProvvMeter").text = str(health) + " / " + str(max_health)
