tool
extends Resource

# Grazie willnationsdev

class_name DifficultyClass

export var _element_type: Script = null setget set_element_type

export var data := [] setget set_data

func set_data(p_value: Array) -> void:
	# Validate element types.
	# Only necessary because Godot doesn't yet have typed Arrays
	# or exportable user-defined Resource types. Hopefully coming for 4.0.
	for i in len(p_value):
		var elem = p_value[i]
		if typeof(elem) != TYPE_OBJECT or elem.get_script() != _element_type:
			# Force all invalid entries to become valid entries.
			p_value[i] = _element_type.new()
	
	# Do the assignment
	data = p_value

func set_element_type(p_value: Script) -> void:
	# element_type must be some user-defined class that extends Resource
	# or a Resource-derivative.
	if p_value:
		var base = p_value.get_instance_base_type()
		if not ClassDB.is_parent_class(base, "Resource"):
			push_error("Assigning invalid type as DifficultyClass element.")
			return
	_element_type = p_value
