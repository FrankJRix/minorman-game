extends Node

class_name CaveGenerator

const INITIAL_RATIO = 0.6
const NEIGHBOURHOOD_TRESHOLD = 4
const NUMBER_OF_STEPS = 5

const MINIMUM_CAVE_AREA = 750

const ROCK = 1
const FREE_SPACE = 0


export var CAVE_WIDTH = 52
export var CAVE_HEIGHT = 52

var map := []
# This holds a 2D array of dictionaries of the following structure:
# cell = { "state": rock or not, "tunnel_id": which tunnel the cell belongs to, "weight": weight of the tile for a* }

var previous_map := []

var tunnels = {} # list of tunnels and related data
# { "(id)": { "start": Vector2 coordinate, "area": numero di caselle } }

var largest_tunnel = {
	"id": 0,
	"area": 0
}

var botched = false

func initialize_map():
	botched = false
	map = []
	tunnels = {}
	
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


func cellular_automaton_step():
	previous_map = map.duplicate(true)
	
	for i in (CAVE_WIDTH - 4):
		for j in (CAVE_HEIGHT - 4):
			evolve(i+2, j+2)


func evolve(i, j):
	if count_neighbourhood(i, j) >= NEIGHBOURHOOD_TRESHOLD:
		map[i][j]["state"] = ROCK
	else:
		map[i][j]["state"] = FREE_SPACE


func evaluate_map():
	var cave_area = 0
	
	for i in tunnels:
		cave_area += tunnels[i]["area"]
	
	if cave_area == 0:
		botched = true
	
	print("Total area: " + str(cave_area))


func count_neighbourhood(i, j):
	var count := 0
	
	if not is_on_boundary(i, j):
		for x in [i - 1, i, i + 1]:
			for y in [j - 1, j, j + 1]:
				count += previous_map[x][y]["state"]
		count -= previous_map[i][j]["state"]
	
	return count


func count_neighbourhood_at_present(i, j):
	var count := 0
	
	if not is_on_boundary(i, j):
		for x in [i - 1, i, i + 1]:
			for y in [j - 1, j, j + 1]:
				count += map[x][y]["state"]
		count -= map[i][j]["state"]
	
	return count


func is_on_boundary(i, j):
	return i <= 1 or i >= CAVE_WIDTH - 2 or j <= 1 or j >= CAVE_HEIGHT - 2


func identify_tunnels():
	var id = 0
	
	for i in CAVE_WIDTH:
		for j in CAVE_HEIGHT:
			if map[i][j]["state"] == FREE_SPACE and map[i][j]["tunnel_id"] == 0:
				id += 1
				mark_tunnel(i, j, id)
	
	print("Number of tunnels: " + str(id))
	print("The largest tunnel is #" + str(largest_tunnel["id"]) + ", with an area of: " + str(largest_tunnel["area"]) + ".")
	print(tunnels)


func mark_tunnel(i, j, id):
	map[i][j]["tunnel_id"] = id
	tunnels[str(id)] = {}
	
	var start = Vector2(i, j)
	tunnels[str(id)]["start"] = start
	var current: Vector2
	var frontier = []
	
	var tunnel_data = {}
	tunnel_data["id"] = id
	tunnel_data["area"] = 1
	
	frontier.push_front(start)
	
	while not frontier.size() == 0:
		current = frontier.pop_front()
		for next in get_frontier_neighbors(current):
			if is_visitable(next) and is_not_visited(next):
				frontier.push_front(next)
				set_tile_id(next, id)
				tunnel_data["area"] += 1
	
	if tunnel_data["area"] > largest_tunnel["area"]:
		largest_tunnel = tunnel_data.duplicate(true)
	
	print("Tunnel #" + str(id) + " has an area of: " + str(tunnel_data["area"]) + ".")
	
	tunnels[str(id)]["area"] = tunnel_data["area"]


func get_frontier_neighbors(point):
	var x = point.x
	var y = point.y
	
	return [Vector2(x, y-1), Vector2(x, y+1), Vector2(x-1, y), Vector2(x+1, y)]


func is_visitable(pos):
	return map[pos.x][pos.y]["state"] == FREE_SPACE


func is_not_visited(pos):
	return map[pos.x][pos.y]["tunnel_id"] == 0


func set_tile_id(tile_pos, id):
	map[tile_pos.x][tile_pos.y]["tunnel_id"] = id


func setup_map():
	randomize()
	initialize_map()
	for i in NUMBER_OF_STEPS:
		cellular_automaton_step()
	identify_tunnels()
	evaluate_map()
