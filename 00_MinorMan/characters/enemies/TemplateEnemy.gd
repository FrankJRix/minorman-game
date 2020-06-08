extends Entity

const MAX_SPEED = 500

var weapon_slot_nodepath: NodePath = "CenterPivot/WeaponSlot"

func get_equipped_weapon():
	return get_node(weapon_slot_nodepath).get_child(0)
