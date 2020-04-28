tool
extends Resource

# Grazie willnationsdev

class_name TierClass

export (Vector2) var tier_range = Vector2()
export (int, 0, 1000) var step = 0
export var enemies_list := [] setget set_enemies_list
export var loot_list := [] setget set_loot_list

var spawnable: Script = preload("res://classes/procedural_generation/DifficultyTiers/spawnable.gd")


func set_enemies_list(p_value: Array) -> void:
	# Validate element types.
	# Only necessary because Godot doesn't yet have typed Arrays
	# or exportable user-defined Resource types. Hopefully coming for 4.0.
	for i in len(p_value):
		var elem = p_value[i]
		if typeof(elem) != TYPE_OBJECT or elem.get_script() != spawnable:
			# Force all invalid entries to become valid entries.
			p_value[i] = spawnable.new()
			
			if not p_value[i].resource_name:
				p_value[i].resource_name = "generic enemy"
	
	# Do the assignment
	enemies_list = p_value


func set_loot_list(p_value: Array) -> void:
	# Validate element types.
	# Only necessary because Godot doesn't yet have typed Arrays
	# or exportable user-defined Resource types. Hopefully coming for 4.0.
	for i in len(p_value):
		var elem = p_value[i]
		if typeof(elem) != TYPE_OBJECT or elem.get_script() != spawnable:
			# Force all invalid entries to become valid entries.
			p_value[i] = spawnable.new()
			
			if not p_value[i].resource_name:
				p_value[i].resource_name = "generic loot"
	
	# Do the assignment
	loot_list = p_value


























