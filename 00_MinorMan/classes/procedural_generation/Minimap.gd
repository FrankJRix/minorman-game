extends TileMap

const ROCK = 1
const FREE_SPACE = 0

const SCALE = 0.05

func update_minimap(map):
	
	for i in map.size():
		for j in map[i].size():
			if map[i][j] == ROCK:
				set_cell(i, j, 0)
			else:
				set_cell(i, j, 1)


func update_player_marker(player_position):
	$PlayerMarker.position = player_position * SCALE
