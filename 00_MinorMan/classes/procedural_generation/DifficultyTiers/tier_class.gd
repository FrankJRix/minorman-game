tool
extends Resource

class_name TierClass

export (int, 0, 1000) var end = 0
export var enemies_list := [] setget set_enemies_list
export var loot_list := [] setget set_loot_list

func set_enemies_list(p_value: Array) -> void:
	# Validate element types.
	# Only necessary because Godot doesn't yet have typed Arrays
	# or exportable user-defined Resource types. Hopefully coming for 4.0.
	for i in len(p_value):
		var elem = p_value[i]
		if typeof(elem) != TYPE_STRING:
			# Force all invalid entries to become valid entries.
			p_value[i] = "enemy path"
	
	# Do the assignment
	enemies_list = p_value

func set_loot_list(p_value: Array) -> void:
	# Validate element types.
	# Only necessary because Godot doesn't yet have typed Arrays
	# or exportable user-defined Resource types. Hopefully coming for 4.0.
	for i in len(p_value):
		var elem = p_value[i]
		if typeof(elem) != TYPE_STRING:
			# Force all invalid entries to become valid entries.
			p_value[i] = "loot path"
	
	# Do the assignment
	loot_list = p_value
