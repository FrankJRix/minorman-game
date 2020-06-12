extends Mob

func hostility_conditions():
	var hostile = acquire_target()
	
	if hostile:
		return true
	else:
		return false
