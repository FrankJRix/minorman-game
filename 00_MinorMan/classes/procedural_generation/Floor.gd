extends TileMap

func build_map(map):
	
	for i in map.get_size().x:
		for j in map.get_size().y:
			set_cell(i, j, 0)
	
	update_bitmask_region()
