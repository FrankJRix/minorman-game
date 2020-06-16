extends Mob

const SIGHT_ANGLE = PI/2

func hostility_conditions():
	var hostile = acquire_target()
	
	if hostile:
		if in_sight(hostile):
			return true
		else:
			return false
	else:
		return false


func in_sight(target):
	var relative_position = target.global_position - global_position
	var relative_angle = abs(last_facing_direction.angle_to(relative_position))
	
	if relative_angle <= SIGHT_ANGLE:
		return true
	else:
		return false
