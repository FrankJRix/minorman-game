extends TileMap

const ROCK = 1
const FREE_SPACE = 0

func update_minimap(map):
	
	for i in map.size():
		for j in map[i].size():
			if map[i][j] == ROCK:
				set_cell(i, j, 0)
			else:
				set_cell(i, j, 1)
