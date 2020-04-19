extends TileMap

var current_map

func build_map(map, width, height):
	current_map = map.get_duplicate()
	write_minimap()
	
	for i in width:
		for j in height:
			set_cell(i, j, int( map.is_state_rock(i, j) ) - 1)
	
	update_bitmask_region()


func write_minimap():
	get_tree().call_group("GUI", "update_minimap", current_map)
