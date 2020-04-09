extends Node

const CAVE_WIDTH = 50
const CAVE_HEIGHT = 50
const INITIAL_RATIO = 0.6
const NEIGHBOURHOOD_TRESHOLD = 4
const NUMBER_OF_STEPS = 5

const MINIMUM_CAVE_AREA = 750

const TEST_TILE_SIZE = 16
const ROCK = 1
const FREE_SPACE = 0

onready var tilemap = $YSort/Walls

var map := []
var previous_map := []

var largest_tunnel = {
	"id": 0,
	"area": 0
}

#lammerda
var evaluation_color := Color.white
var tile

func _ready():
	randomize()
	initialize_map()
	#read_map()
	build_cave_map()


func initialize_map():
	map = []
	
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
	
	evaluation_color = Color.white if cave_area > MINIMUM_CAVE_AREA else Color.red
	
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


func build_cave_map():
	tilemap.build_map(map, CAVE_WIDTH, CAVE_HEIGHT)


func _input(event):
	if Input.is_action_just_pressed("test_input"):
		#clear_map()
		for i in NUMBER_OF_STEPS:
			cellular_automaton_step()
		identify_tunnels()
		evaluate()
		#read_map()
		build_cave_map()


#######################################################################################EOF

# Obsolete, lammerda, qui come memento di roba inefficiente.
func read_map():
	for i in CAVE_WIDTH:
		for j in CAVE_HEIGHT:
			tile = ColorRect.new()
			tile.color = evaluation_color if map[i][j]["state"] == 0 else Color.darkslategray
			tile.rect_min_size = Vector2(TEST_TILE_SIZE, TEST_TILE_SIZE)
			tile.rect_global_position = Vector2(i * TEST_TILE_SIZE, j * TEST_TILE_SIZE)
			add_child(tile)


func clear_map():
	for child in get_children():
		child.queue_free()
