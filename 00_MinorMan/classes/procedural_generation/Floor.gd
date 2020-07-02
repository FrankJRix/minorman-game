extends TileMap

func build_map(map: MapGrid):
	
	for i in map.get_size().x:
		for j in map.get_size().y:
			set_cell(i, j, 0 if map.noise_map.get_noise_2d(i,j) < 0.3 else 1)
	
	update_bitmask_region()
