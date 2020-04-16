extends Reference

class_name MapCell

var coordinates := Vector2() setget set_coordinates, get_coordinates
var state := 0 setget set_state, get_state
var tunnel_id := 0 setget set_tunnel_id, get_tunnel_id
var number_of_neighbors := 0 setget set_number_of_neighbors, get_number_of_neighbors
var spawn_id := 0 setget set_spawn_id, get_spawn_id
var is_wall := false setget set_wall, get_is_wall
var cost := 1 setget set_cost, get_cost


func construct(x: int, y: int, content: int):
	self.set_coordinates(Vector2(x,y))
	self.set_state(content)


func set_coordinates(value: Vector2):
	coordinates = value

func get_coordinates():
	return coordinates


func set_state(value: int):
	state = value

func get_state():
	return state


func set_tunnel_id(value: int):
	tunnel_id = value

func get_tunnel_id():
	return tunnel_id


func set_number_of_neighbors(value: int):
	number_of_neighbors = value

func get_number_of_neighbors():
	return number_of_neighbors


func set_spawn_id(value: int):
	spawn_id = value

func get_spawn_id():
	return spawn_id


func set_wall(value: bool):
	is_wall = value

func get_is_wall():
	return is_wall


func set_cost(value: int):
	cost = value

func get_cost():
	return cost

func add_cost(value: int):
	cost += value









