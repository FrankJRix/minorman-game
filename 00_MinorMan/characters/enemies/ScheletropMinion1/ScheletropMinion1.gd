extends Mob

func hostility_conditions():
	return bool(acquire_target())


func acquire_target():
	var possible_targets = get_tree().get_nodes_in_group("active_entities")
	var hostile_targets: Array
	
	for element in possible_targets:
		for faction in hostile_factions:
			if element.is_in_group(faction):
				hostile_targets.append(element)
	
#	for element in hostile_targets:
		
