extends TileMap

const ROCK = 1
const FREE_SPACE = 0

const SCALE = 0.05

onready var camera = $PlayerMarker/Camera2D

func update_minimap(map):
	
	for i in map.size():
		for j in map[i].size():
			if map[i][j]["state"] == ROCK:
				set_cell(i, j, 0)
			else:
				set_cell(i, j, map[i][j]["tunnel_id"] % 9 + 1)
	
	#set_camera_limits()


func update_player_marker(player_position):
	$PlayerMarker.position = player_position * SCALE


func set_camera_limits():
	var limit_left = 200
	var limit_right = 200 - get_used_rect().size.x
	var limit_top
	var limit_bottom
	
	camera.limit_left = limit_left
	camera.limit_right = limit_right
