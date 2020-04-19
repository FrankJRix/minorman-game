extends Node

class_name CaveGenerator

# Best thus far:
#const INITIAL_RATIO = 0.6               FREE_SPACE if randf() < INITIAL_RATIO else ROCK
#const NEIGHBOURHOOD_TRESHOLD = 4
#const NUMBER_OF_STEPS = 5

const INITIAL_RATIO = 0.6
const NEIGHBOURHOOD_TRESHOLD = 4
const NUMBER_OF_STEPS = 6

const MINIMUM_CAVE_AREA = 750

const ROCK = 1
const FREE_SPACE = 0
enum SPAWN_ID {PLAYER, ENEMY, LOOT}

export var CAVE_WIDTH = 54
export var CAVE_HEIGHT = 54

var map := MapGrid.new()

var previous_map: MapGrid

var tunnels = {} # list of tunnels and related data
# { "(id)": { "start": Vector2 coordinate, "area": numero di caselle } }

var largest_tunnel = {
	"id": 0,
	"area": 0
}

var botched = false


func flush_old_data():
	botched = false
	
	tunnels = {}
	
	largest_tunnel = {
	"id": 0,
	"area": 0
	}


func initialize_empty_map():
	map.initialize_empty(CAVE_WIDTH, CAVE_HEIGHT)


func cellular_automaton_step():
	previous_map = map.get_duplicate()
	
	for i in (CAVE_WIDTH - 4):
		for j in (CAVE_HEIGHT - 4):
			evolve(i+2, j+2)


func evolve(i, j):
	map.set_rock_state(i, j, count_neighbourhood(i, j) >= NEIGHBOURHOOD_TRESHOLD)


func evaluate_map():
	var cave_area = 0
	
	for i in tunnels:
		cave_area += tunnels[i]["area"]
	
	if cave_area == 0:
		botched = true
	
	print("Total area: " + str(cave_area))


func count_neighbourhood(i, j):                                 # togliere l'if?
	var count := 0
	
	for x in [i - 1, i, i + 1]:
		for y in [j - 1, j, j + 1]:
			count += int( previous_map.is_state_rock(x, y) )
	
	count -= int( previous_map.is_state_rock(i, j) )
	
	return count


func count_neighbourhood_at_present(i, j):
	var count := 0
	
	for x in [i - 1, i, i + 1]:
		for y in [j - 1, j, j + 1]:
			count += int( map.is_state_rock(x, y) )
	count -= int( map.is_state_rock(i, j) )
	
	return count


func identify_tunnels():
	var id = 0
	
	for i in CAVE_WIDTH:
		for j in CAVE_HEIGHT:
			if not map.is_state_rock(i, j) and map.get_tunnel_id(i, j) == 0:
				id += 1
				mark_tunnel(i, j, id)
	
	print("Number of tunnels: " + str(id))
	print("The largest tunnel is #" + str(largest_tunnel["id"]) + ", with an area of: " + str(largest_tunnel["area"]) + ".")
	print(tunnels)


func mark_tunnel(i, j, id):
	map.set_tunnel_id(i, j, id)
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
				map.set_tunnel_id(next.x, next.y, id)
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
	return not map.is_state_rock(pos.x, pos.y)


func is_not_visited(pos):
	return map.get_tunnel_id(pos.x, pos.y) == 0


func fetch_spawn_point():
	var ideal_spawn: Vector2
	
	for i in CAVE_WIDTH:
		for j in CAVE_HEIGHT:
			if map.get_tunnel_id(i, j) == largest_tunnel["id"] and count_neighbourhood_at_present(i, j) == 0:
				ideal_spawn = Vector2(i, j)
				break
	
	if  not ideal_spawn:
		print("--------------------------------------Could not find suitable spawn point.---------------------------------------------------------")
		botched = true
	
	return ideal_spawn


func setup_map():
	randomize()
	flush_old_data()
	initialize_empty_map()
	map.randomize_map(INITIAL_RATIO)
	for i in NUMBER_OF_STEPS:
		cellular_automaton_step()
	identify_tunnels()
	evaluate_map()
