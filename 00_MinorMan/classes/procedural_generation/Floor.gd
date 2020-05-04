extends TileMap

func build_map(width, height):
	
	for i in width:
		for j in height:
			set_cell(i, j, 0)
	
	update_bitmask_region()
