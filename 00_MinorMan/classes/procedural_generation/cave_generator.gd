extends Node

class_name CaveGenerator

const CAVE_WIDTH = 50
const CAVE_HEIGHT = 50
const INITIAL_RATIO = 0.6
const NEIGHBOURHOOD_TRESHOLD = 4
const NUMBER_OF_STEPS = 5

const MINIMUM_CAVE_AREA = 750

const ROCK = 1
const FREE_SPACE = 0


var map := []
# This holds a 2D array of dictionaries of the following structure:
# cell = { "state": rock or not, "tunnel_id": which tunnel the cell belongs to, "weight": weight of the tile for a* }

var previous_map := []

var largest_tunnel = {
	"id": 0,
	"area": 0
}


func initialize_map():
	map = []
	
	largest_tunnel = {
	"id": 0,
	"area": 0
	}
	
	for i in CAVE_WIDTH:
		map.append([])
		for j in CAVE_HEIGHT:
			map[i].append({
				"state": FREE_SPACE if randf() < INITIAL_RATIO else ROCK,
				"tunnel_id": 0
			})
			if is_on_boundary(i, j):
				map[i][j]["state"] = ROCK


func count_neighbourhood(i, j):
	var count = 0
	
	if not is_on_boundary(i, j):
		for x in [i - 1, i, i + 1]:
			for y in [j - 1, j, j + 1]:
				count += previous_map[x][y]["state"]
		count -= previous_map[i][j]["state"]
	
	return int(count)


func is_on_boundary(i, j):
	return i == 0 or i == CAVE_WIDTH - 1 or j == 0 or j == CAVE_HEIGHT - 1


func evolve(i, j):
	if count_neighbourhood(i, j) >= NEIGHBOURHOOD_TRESHOLD:
		map[i][j]["state"] = ROCK
	else:
		map[i][j]["state"] = FREE_SPACE


func cellular_automaton_step():
	previous_map = map.duplicate(true)
	
	for i in (CAVE_WIDTH - 2):
		for j in (CAVE_HEIGHT - 2):
			evolve(i+1, j+1)


func evaluate():
	var cave_area = 0
	
	for i in CAVE_WIDTH:
		for j in CAVE_HEIGHT:
			cave_area += map[i][j]["state"]
	
	cave_area = CAVE_WIDTH * CAVE_HEIGHT - cave_area
	
	print("Total area: " + str(cave_area))


func identify_tunnels():
	var id = 0
	
	for i in CAVE_WIDTH:
		for j in CAVE_HEIGHT:
			if map[i][j]["state"] == FREE_SPACE and map[i][j]["tunnel_id"] == 0:
				id += 1
				mark_tunnel(i, j, id)
	
	print("Number of tunnels: " + str(id))
	print("The largest tunnel is #" + str(largest_tunnel["id"]) + ", with an area of: " + str(largest_tunnel["area"]) + ".")


func mark_tunnel(i, j, id):
	map[i][j]["tunnel_id"] = id
	
	var start = Vector2(i, j)
	var current: Vector2
	var frontier = []
	
	var tunnel_data = {}
	tunnel_data["id"] = id
	tunnel_data["area"] = 1
	
	frontier.push_front(start)
	
	while not frontier.size() == 0:
		current = frontier.pop_front()
		for next in get_frontier_neighbors(current):
			if is_visitable_and_not_visited(next):
				frontier.push_front(next)
				set_tile_id(next, id)
				tunnel_data["area"] += 1
	
	if tunnel_data["area"] > largest_tunnel["area"]:
		largest_tunnel = tunnel_data.duplicate(true)
	
	print("Tunnel #" + str(tunnel_data["id"]) + " has an area of: " + str(tunnel_data["area"]) + ".")


func get_frontier_neighbors(point):
	var x = point.x
	var y = point.y
	
	return [Vector2(x, y-1), Vector2(x, y+1), Vector2(x-1, y), Vector2(x+1, y)]


func is_visitable_and_not_visited(pos):
	return map[pos.x][pos.y]["state"] == FREE_SPACE and map[pos.x][pos.y]["tunnel_id"] == 0


func set_tile_id(tile_pos, id):
	map[tile_pos.x][tile_pos.y]["tunnel_id"] = id


# Ovviamente qui c'è un bug. Perché i vicini che conto stanno sulla generazione precedente. Però il comportamento è interessante, 
# perché sembra introdurre un bias selettivo che aggiunge, piuttosto che togliere.
func fetch_spawn_point():
	var ideal_spawn
	
	for i in CAVE_WIDTH:
		for j in CAVE_HEIGHT:
			if map[i][j]["tunnel_id"] == largest_tunnel["id"] and count_neighbourhood(i, j) == 0:
				ideal_spawn = Vector2(i, j)
				break
	
	if  not ideal_spawn:
		print("Could not find suitable spawn point.")
		setup_map()
	
	return ideal_spawn


func setup_map():
	randomize()
	initialize_map()
	for i in NUMBER_OF_STEPS:
		cellular_automaton_step()
	identify_tunnels()
	evaluate()
