extends TileMap

const ROCK = 1
const FREE_SPACE = 0

const SCALE = 0.05

onready var camera = $PlayerMarker/Camera2D

func update_minimap(map):
	
	for i in map.get_size().x:
		for j in map.get_size().y:
			if map.is_state_rock(i, j):
				set_cell( i, j, 0)
			else:
				set_cell(i, j, map.get_tunnel_id(i, j) % 9 + 1)


func update_player_marker(player_position):
	$PlayerMarker.position = player_position * SCALE
