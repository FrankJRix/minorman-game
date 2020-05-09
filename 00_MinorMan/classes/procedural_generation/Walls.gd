extends TileMap


func build_map(map):
	write_minimap(map)
	
	for i in map.get_size().x:
		for j in map.get_size().y:
			set_cell(i, j, int( map.is_state_rock(i, j) ) - 1)
	
	update_bitmask_region()


func write_minimap(current_map):
	get_tree().call_group("GUI", "update_minimap", current_map)
