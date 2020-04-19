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

const MAX_MOVEMENT_COST = 1000
const MIN_MOVEMENT_COST = 1

var map:= []

# Whole map functions
# Svuota la mappa, poi la costruisce con w*h celle vuote.
func initialize_empty(width: int, height: int):
	
	self.flush()
	
	for i in width:
		
		map.append([])
		
		for j in height:
			
			map[i].append({})
			set_empty_cell(i, j)

# Randomizes map content and builds wall
func randomize_map(ratio: float):
	randomize()
	
	for i in self.get_size().x:
		for j in self.get_size().y:
			self.set_rock_state(i, j, ( randf() > ratio ) or is_on_boundary(i, j))

# True se la cella è sul bordo 
func is_on_boundary(i, j):
	return i <= 1 or i >= self.get_size().x - 2 or j <= 1 or j >= self.get_size().y - 2

# Outputta una copia esatta della mappa
func get_duplicate():
	var copy = get_script().new()
	copy.map = map.duplicate(true)
	return copy

# Outputta un Vector2 contenente le dimensioni della mappa
func get_size():
	var width = map.size()
	var height = map[0].size()
	
	return Vector2(width, height)

# Resetta completamente la mappa
func flush():
	map = []


# Individual cell functions
func set_empty_cell(x: int, y: int):
	map[x][y]["coordinates"] = Vector2(x, y)
	map[x][y]["rock"] = false
	map[x][y]["tunnel_id"] = 0
	map[x][y]["wall"] = false
	map[x][y]["number_of_neighbors"] = 0
	map[x][y]["cost_of_movement"] = 1
	map[x][y]["spawn_placeholder_id"] = 0

func get_map_cell(x: int, y: int):
	return map[x][y].duplicate(true)

# Coordinates functions
func set_coordinates(x: int, y: int):
	map[x][y]["coordinates"] = Vector2(x, y)

func set_coordinatesv(v: Vector2):
	map[v.x][v.y]["coordinates"] = v

func get_coordinates(x: int, y: int):
	return map[x][y]["coordinates"]

func get_coordinatesv(v: Vector2):
	return map[v.x][v.y]["coordinates"]


# State functions
func set_rock_state(x: int, y: int, value: bool):
	map[x][y]["rock"] = value

func is_state_rock(x: int, y: int):
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
	map[x][y]["cost_of_movement"] = clamp(value, MIN_MOVEMENT_COST, MAX_MOVEMENT_COST)

func get_cost(x: int, y: int):
	return map[x][y]["cost_of_movement"]

func add_cost(x: int, y: int, value: int):
	map[x][y]["cost_of_movement"] = clamp(map[x][y]["cost_of_movement"] + value, MIN_MOVEMENT_COST, MAX_MOVEMENT_COST)

func sub_cost(x: int, y: int, value: int):
	map[x][y]["cost_of_movement"] = clamp(map[x][y]["cost_of_movement"] - value, MIN_MOVEMENT_COST, MAX_MOVEMENT_COST)
