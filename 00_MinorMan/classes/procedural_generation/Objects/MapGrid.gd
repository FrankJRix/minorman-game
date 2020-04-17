extends Reference

class_name MapGrid

# Contains an array of dictionaries whose keys are all accessed via functions.
# 
# {
# "coordinates": Vector2
# "rock": bool
# "tunnel_id": int
# "wall": bool
# "number_of_neighbors": int
# "cost_of_movement": int
# "spawn_placeholder_id": int
# }

var map:= []

# Whole map functions
func initialize_empty(width: int, height: int):
	
	for i in width:
		
		map.append([])
		
		for j in height:
			
			map[i].append({})
			set_empty_cell(i, j)

func duplicate():
	return map.duplicate(true)


# Individual cell functions
func set_empty_cell(x: int, y: int):
	map[x][y]["coordinates"] = Vector2(x, y)
	map[x][y]["rock"] = false
	map[x][y]["tunnel_id"] = 0
	map[x][y]["wall"] = false
	map[x][y]["number_of_neighbors"] = 0
	map[x][y]["cost_of_movement"] = 1
	map[x][y]["spawn_placeholder_id"] = 0

func get_map_cell(x, y):
	return map[x][y].duplicate(true)

# Coordinates functions
func set_coordinates(x, y):
	map[x][y]["coordinates"] = Vector2(x, y)

func set_coordinatesv(v: Vector2):
	map[v.x][v.y]["coordinates"] = v

func get_coordinates(x, y):
	return map[x][y]["coordinates"]

func get_coordinatesv(v: Vector2):
	return map[v.x][v.y]["coordinates"]


# State functions
func set_rock_state(x: int, y: int, value: bool):
	map[x][y]["rock"] = value

func get_rock_state(x: int, y: int):
	return map[x][y]["rock"]


# Tunnel id functions
func set_tunnel_id(x: int, y: int, value: int):
	map[x][y]["tunnel_id"] = value

func get_tunnel_id(x: int, y: int):
	return map[x][y]["tunnel_id"]


# Neighbor number functions
func set_number_of_neighbors(x: int, y: int, value: int):
	map[x][y]["number_of_neighbors"] = value

func get_number_of_neighbors(x: int, y: int):
	return map[x][y]["number_of_neighbors"]


# Spawn id functions
func set_spawn_id(x: int, y: int, value: int):
	map[x][y]["spawn_placeholder_id"] = value

func get_spawn_id(x: int, y: int):
	return map[x][y]["spawn_placeholder_id"]


# Wall functions
func set_wall(x: int, y: int, value: bool):
	map[x][y]["wall"] = value

func is_wall(x: int, y: int):
	return map[x][y]["wall"]


# Movement cost functions
func set_cost(x: int, y: int, value: int):
	map[x][y]["cost_of_movement"] = value

func get_cost(x: int, y: int):
	return map[x][y]["cost_of_movement"]

func add_cost(x: int, y: int, value: int):
	map[x][y]["cost_of_movement"] = clamp(map[x][y]["cost_of_movement"] + value, 1, 100)

func sub_cost(x: int, y: int, value: int):
	map[x][y]["cost_of_movement"] = clamp(map[x][y]["cost_of_movement"] - value, 1, 100)
