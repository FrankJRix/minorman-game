extends Reference

class_name MapGrid
##
# Da riscrivere. Adesso è tutta la mappa.
##
# Contains an array of dictionaries whose keys are all accessed via functions.
# 
# {
# "coordinates": Vector2
# "state": int
# "tunnel_id": int
# "is_wall": bool
# "number_of_neighbors": int
# "cost_of_movement": int
# "spawn_placeholder_id": int
# }
# 
var coordinates := Vector2() setget set_coordinates, get_coordinates
var state := 0 setget set_state, get_state
var tunnel_id := 0 setget set_tunnel_id, get_tunnel_id
var number_of_neighbors := 0 setget set_number_of_neighbors, get_number_of_neighbors
var spawn_id := 0 setget set_spawn_id, get_spawn_id
var is_wall := false setget set_wall, get_is_wall
var cost := 1 setget set_cost, get_cost

var map:= []


func initialize_empty(width: int, height: int):
	
	for i in width:
		map.append([])
		for j in height:
			map[i].append({
				 "coordinates": 0,
				 "state": 0,
				 "tunnel_id": 0,
				 "is_wall": 0,
				 "number_of_neighbors": 0,
				 "cost_of_movement": 0,
				 "spawn_placeholder_id": 0,
			})


# Coordinates functions
func set_coordinates(value: Vector2):
	coordinates = value

func get_coordinates():
	return coordinates


# State functions
func set_state(value: int):
	state = value

func get_state():
	return state


# Tunnel id functions
func set_tunnel_id(value: int):
	tunnel_id = value

func get_tunnel_id():
	return tunnel_id


# Neighbor number functions
func set_number_of_neighbors(value: int):
	number_of_neighbors = value

func get_number_of_neighbors():
	return number_of_neighbors


# Spawn id functions
func set_spawn_id(value: int):
	spawn_id = value

func get_spawn_id():
	return spawn_id


# Wall functions
func set_wall(value: bool):
	is_wall = value

func get_is_wall():
	return is_wall


# Movement cost functions
func set_cost(value: int):
	cost = value

func get_cost():
	return cost

func add_cost(value: int):
	cost += value









