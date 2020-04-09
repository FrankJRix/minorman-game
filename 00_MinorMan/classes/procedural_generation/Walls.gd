extends TileMap

signal tile_updated(tile)

var current_map

func build_map(map, width, height):
	current_map = map.duplicate(true)
	write_minimap()
	
	for i in width:
		for j in height:
			set_cell(i, j, map[i][j]["state"] - 1)
	
	update_bitmask_region()


func write_minimap():
	get_tree().call_group("GUI", "update_minimap", current_map)
