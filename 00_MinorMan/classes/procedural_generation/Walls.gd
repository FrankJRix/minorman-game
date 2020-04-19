extends TileMap


func build_map(map, width, height):
	write_minimap(map)
	
	for i in width:
		for j in height:
			set_cell(i, j, int( map.is_state_rock(i, j) ) - 1)
	
	update_bitmask_region()


func write_minimap(current_map):
	get_tree().call_group("GUI", "update_minimap", current_map)
