tool
extends Resource

# Grazie willnationsdev
# Anche se ce sò rimasti solo i commenti quasi. Però m'ha insegnato a usà tool.

class_name DifficultyClass

export var tiers := [] setget set_data

var tier_type: Script = preload("res://classes/procedural_generation/DifficultyTiers/tier_class.gd") 

func set_data(p_value: Array) -> void:
	# Validate element types.
	# Only necessary because Godot doesn't yet have typed Arrays
	# or exportable user-defined Resource types. Hopefully coming for 4.0.
	for i in len(p_value):
		var elem = p_value[i]
		if typeof(elem) != TYPE_OBJECT or elem.get_script() != tier_type:
			# Force all invalid entries to become valid entries.
			p_value[i] = tier_type.new()
			
			if not p_value[i].resource_name:
				p_value[i].resource_name = "BlankTier"
	
	# Do the assignment
	tiers = p_value
