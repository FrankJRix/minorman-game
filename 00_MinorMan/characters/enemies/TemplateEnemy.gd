extends Entity

class_name Mob

const MAX_SPEED = 500

var weapon_slot_nodepath: NodePath = "CenterPivot/WeaponSlot"


func get_equipped_weapon():
	return get_node(weapon_slot_nodepath).get_child(0)


func add_to_appropriate_faction():
	add_to_group(Data.factions["enemy"])


func hostility_conditions():
	return false
