extends TileMap

const ROCK = 1
const FREE_SPACE = 0

const SCALE = 0.05

onready var camera = $PlayerMarker/Camera2D

func update_minimap(map: MapGrid):
	
	for i in map.get_size().x:
		for j in map.get_size().y:
			if map.is_wall(i,j):
				set_cell( i, j, 11)
			elif map.is_state_rock(i, j):
				set_cell( i, j, 0)
			else:
				var color_index = int( (floor((map.get_danger_level(i, j) - 1)) / 100 )) + 1# UNSTABLE
				set_cell(i, j, color_index)
	
	camera.limit_right = map.get_size().x * cell_size.x
	camera.limit_bottom = map.get_size().y * cell_size.x


func update_player_marker(player_position):
	$PlayerMarker.position = player_position * SCALE


func update_mined_tiles(point):
	set_cellv(point, 10)
