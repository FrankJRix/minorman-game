extends Reference

class_name MapGrid

# Contains an array of dictionaries whose keys are all accessed via functions.
# 
# {
# 1		"coordinates": Vector2
# 2		"rock": bool
# 3		"tunnel_id": int
# 4		"wall": bool
# 5		"number_of_neighbors": int
# 6		"spawn_placeholder_id": int
# 7		"cost_of_movement": int
# 8		"danger_level": int
# 9		"is_main": bool
# }

const MAX_MOVEMENT_COST = 1000
const MIN_MOVEMENT_COST = 1
const MAX_DANGER_LEVEL = 1000
const MIN_DANGER_LEVEL = 1

var map:= []
var noise_map: OpenSimplexNoise = null

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
func randomize_map(ratio: float, current_seed: int):
	noise_map = OpenSimplexNoise.new()
	
	noise_map.seed = current_seed
	noise_map.octaves = 1
	noise_map.period = 8
	
	seed(current_seed)
	
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
	map[x][y]["coordinates"] = Vector2(x, y)	#1
	map[x][y]["rock"] = false					#2
	map[x][y]["tunnel_id"] = 0					#3
	map[x][y]["wall"] = false					#4
	map[x][y]["number_of_neighbors"] = 0		#5
	map[x][y]["spawn_placeholder_id"] = 0		#6
	map[x][y]["cost_of_movement"] = 1			#7
	map[x][y]["danger_level"] = 1				#8
	map[x][y]["is_main"] = false				#9

func get_map_cell(x: int, y: int):						#?
	return map[x][y].duplicate(true)


# 1) Coordinates functions
func set_coordinates(x: int, y: int):
	map[x][y]["coordinates"] = Vector2(x, y)

func set_coordinatesv(v: Vector2):
	map[v.x][v.y]["coordinates"] = v

func get_coordinates(x: int, y: int):
	return map[x][y]["coordinates"]

func get_coordinatesv(v: Vector2):
	return map[v.x][v.y]["coordinates"]


# 2) State functions
func set_rock_state(x: int, y: int, value: bool):
	map[x][y]["rock"] = value

func is_state_rock(x: int, y: int):
	return map[x][y]["rock"]


# 3) Tunnel id functions
func set_tunnel_id(x: int, y: int, value: int):
	map[x][y]["tunnel_id"] = value

func get_tunnel_id(x: int, y: int):
	return map[x][y]["tunnel_id"]


# 4) Wall functions
func set_wall(x: int, y: int, value: bool):
	map[x][y]["wall"] = value

func is_wall(x: int, y: int):
	return map[x][y]["wall"]


# 5) Neighbor number functions
func set_number_of_neighbors(x: int, y: int, value: int):
	map[x][y]["number_of_neighbors"] = value

func get_number_of_neighbors(x: int, y: int):
	return map[x][y]["number_of_neighbors"]


# 6) Spawn id functions
func set_spawn_id(x: int, y: int, value: int):
	map[x][y]["spawn_placeholder_id"] = value

func get_spawn_id(x: int, y: int):
	return map[x][y]["spawn_placeholder_id"]


# 7) Movement cost functions
func set_cost(x: int, y: int, value: int):
	map[x][y]["cost_of_movement"] = clamp(value, MIN_MOVEMENT_COST, MAX_MOVEMENT_COST)

func get_cost(x: int, y: int):
	return map[x][y]["cost_of_movement"]

func add_cost(x: int, y: int, value: int):
	map[x][y]["cost_of_movement"] = clamp(map[x][y]["cost_of_movement"] + value, MIN_MOVEMENT_COST, MAX_MOVEMENT_COST)

func sub_cost(x: int, y: int, value: int):
	map[x][y]["cost_of_movement"] = clamp(map[x][y]["cost_of_movement"] - value, MIN_MOVEMENT_COST, MAX_MOVEMENT_COST)


# 8) Danger level functions
func set_danger_level(x: int, y: int, value: int):
	map[x][y]["danger_level"] = clamp(value, MIN_DANGER_LEVEL, MAX_DANGER_LEVEL)

func get_danger_level(x: int, y: int) -> int:
	return map[x][y]["danger_level"]

func add_danger_level(x: int, y: int, value: int):
	map[x][y]["danger_level"] = clamp(map[x][y]["danger_level"] + value, MIN_DANGER_LEVEL, MAX_DANGER_LEVEL)

func sub_danger_level(x: int, y: int, value: int):
	map[x][y]["danger_level"] = clamp(map[x][y]["danger_level"] - value, MIN_DANGER_LEVEL, MAX_DANGER_LEVEL)


# 9) Main Tunnel functions
func set_main(x: int, y: int, value: bool):
	map[x][y]["is_main"] = value

func is_main(x: int, y: int):
	return map[x][y]["is_main"]
