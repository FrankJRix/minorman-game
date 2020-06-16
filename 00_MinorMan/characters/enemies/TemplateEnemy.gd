extends Entity

class_name Mob

export var MAX_SPEED := 500
export var radius := 192

onready var sight_ray: RayCast2D = $Sight
onready var avoid_ray: RayCast2D = $ObstacleAvoider

var weapon_slot_nodepath: NodePath = "CenterPivot/WeaponSlot"
var hostile_factions: Array = [Data.factions["player"], Data.factions["ally"]]
#var current_target: Entity = null
#var last_offender: Entity = null

func get_equipped_weapon():
	print ("attacco")
	return get_node(weapon_slot_nodepath).get_child(0)


func add_to_appropriate_faction():
	add_to_group(Data.factions["enemy"])


func hostility_conditions():
	return false


func acquire_target():
	var possible_targets := get_tree().get_nodes_in_group("active_entities")
	var hostile_targets: Array
	var available_targets: Array
	
	var target: Entity = null
	
	var target_distance: float = INF
	var temp_distance: float
	
	for element in possible_targets:
		for faction in hostile_factions:
			if element.is_in_group(faction) and element != self:
				hostile_targets.append(element)
	
	for element in hostile_targets:
		sight_ray.cast_to = element.global_position - global_position
		sight_ray.force_raycast_update()
		if not sight_ray.is_colliding():
			available_targets.append(element)
	
	for element in available_targets:
		temp_distance = (global_position - element.global_position).length()
		if temp_distance < target_distance:
			target_distance = temp_distance
			target = element
	
	return target
