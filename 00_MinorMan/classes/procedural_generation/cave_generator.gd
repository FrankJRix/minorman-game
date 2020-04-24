extends Node

class_name CaveGenerator

# Best thus far:
#const INITIAL_RATIO = 0.6
#const NEIGHBOURHOOD_TRESHOLD = 4
#const NUMBER_OF_STEPS = 5 or 6 (- step -> + squadrato; + step -> - area)

const RATIO = 0.6
const NEIGHBOURHOOD_TRESHOLD = 4
const NUMBER_OF_STEPS = 6

const MIN_TUNNEL_AREA = 3
const DISTANCE_STEP = 5 # for danger increment

export var CAVE_WIDTH := 100
export var CAVE_HEIGHT := 100
onready var minimum_cave_area: int

var map := MapGrid.new()
var previous_map: MapGrid

var botched := false
var suppressed_count := 0
var gen_num := 0

var max_distance := [0, Vector2()]
enum MAX_DIST_INDEX {VALUE, LOCATION}

enum SPAWN_ID {ZERO, PLAYER, EXIT, ENEMY, LOOT, MINERAL}
var player_spawn_point := Vector2()
var ladder_spawn_point := Vector2()

var points_by_distance := {}

var tunnels := {
	0: { # l'indice è l'id
		"start": Vector2(),
		"area": 0,
		"base_danger": 1
	}
}
var largest_tunnel := {
	"id": 0,
	"area": 0,
	"start": Vector2()
}

signal generation_complete
signal reset_generation

func flush_old_data():
	botched = false
	
	minimum_cave_area = int( floor( (CAVE_WIDTH * CAVE_HEIGHT) / 4 ) )
	
	suppressed_count = 0
	
	player_spawn_point = Vector2()
	ladder_spawn_point = Vector2()
	
	max_distance = [0, Vector2()]
	
	points_by_distance = {}
	
	tunnels = {}
	
	largest_tunnel = {
	"id": 0,
	"area": 0,
	"start": Vector2()
	}


func initialize_empty_map():
	map.initialize_empty(CAVE_WIDTH, CAVE_HEIGHT)


func randomize_map():
	map.randomize_map(RATIO)


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
	
	if cave_area <= minimum_cave_area:
		print("<><><><><><><><><><><><><><><><><><><><><><> TOO SMALL <><><><><><><><><><><><><><><><><><><><><><>")
		botched = true
	
	print("Total area: " + str(cave_area))


func count_neighbourhood(i, j):
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

# Implementare il marchio della morte per eliminare i tunnel isolati piccoli
func identify_tunnels():
	var id = 0
	
	for i in CAVE_WIDTH:
		for j in CAVE_HEIGHT:
			if is_visitable(Vector2(i, j)) and is_not_visited(Vector2(i, j)):
				id += 1
				mark_tunnel(i, j, id)
	
	print("Number of tunnels: " + str(id - suppressed_count))
	print("The largest tunnel is #" + str(largest_tunnel["id"]) + ", with an area of: " + str(largest_tunnel["area"]) + ".")


func mark_tunnel(i, j, id):
	map.set_tunnel_id(i, j, id)
	tunnels[str(id)] = {}
	
	var start = Vector2(i, j)
	tunnels[str(id)]["start"] = start
	tunnels[str(id)]["area"] = 0
	
	traverse_tunnel_and_call_func(start, "mark_tunnel_step", [id])
	
	if tunnels[str(id)]["area"] <= MIN_TUNNEL_AREA:
		print("--------------------------L'area di " + str(id) + " era " + str(tunnels[str(id)]["area"]) + " e poi è stato")
		tunnels[str(id)]["area"] = 0
		suppressed_count += 1
		fill_tunnel_step(start)
		traverse_tunnel_and_call_func(start, "fill_tunnel_step", [])
	
	if tunnels[str(id)]["area"] > largest_tunnel["area"]:
		largest_tunnel["id"] = id
		largest_tunnel["area"] = tunnels[str(id)]["area"]
		largest_tunnel["start"] = start
	
	print("Tunnel #" + str(id) + " has an area of: " + str(tunnels[str(id)]["area"]) + ".")

# Template per tutte le funzioni step, ossia le funzioni da chiamare dentro a traverse_tunnel
# Il vettore delle coordinate va sempre alla fine!
# Deve ritornare false per non uscire dal loop
func mark_tunnel_step(id, coords):
	map.set_tunnel_id(coords.x, coords.y, id)
	tunnels[str(id)]["area"] += 1
	return false


func fill_tunnel_step(coords):
	map.set_empty_cell(coords.x, coords.y)
	map.set_rock_state(coords.x, coords.y, true)
	print("--------------------------------------------------ROCCIATO!")
	return false


func get_frontier_neighbors(point):
	var x = point.x
	var y = point.y
	
	return [Vector2(x, y-1), Vector2(x, y+1), Vector2(x-1, y), Vector2(x+1, y)]


func is_visitable(pos):
	return not map.is_state_rock(pos.x, pos.y)


func is_not_visited(pos):
	return map.get_tunnel_id(pos.x, pos.y) == 0


func is_contiguous(pos, id): # Legacy
	return map.get_tunnel_id(pos.x, pos.y) == id


func fetch_spawn_point():
	var start = largest_tunnel["start"]
	
	traverse_tunnel_and_call_func(start, "fetch_player_spawn_step", [])
	
	map.set_spawn_id(player_spawn_point.x, player_spawn_point.y, SPAWN_ID.PLAYER)
	
	if  not player_spawn_point:
		print("--------------------------------------Could not find suitable spawn point.---------------------------------------------------------")
		botched = true


func fetch_player_spawn_step(coords):
	if count_neighbourhood_at_present(coords.x, coords.y) == 0:
		player_spawn_point = coords
		return true
	else:
		return false


func set_danger_level():
	for tunnel_id in tunnels:
		
		if not tunnels[tunnel_id]["area"] == 0:
			
			tunnels[tunnel_id]["base_danger"] = max(0, map.MAX_DANGER_LEVEL - tunnels[tunnel_id]["area"])
			traverse_tunnel_and_call_func(tunnels[tunnel_id]["start"], "set_danger_step", [tunnels[tunnel_id]["base_danger"]])
			
			print(str(tunnel_id) + ":")
			print(tunnels[tunnel_id])


func set_danger_step(danger, coords):
	map.set_danger_level(coords.x, coords.y, danger)
	return false


# Variazione sul tema di traverse tunnel che tiene conto della distanza. Probabilmente potrei
# riscrive quella per tené conto de sto caso, però tanto la uso solo qui quindi sticazzi.
func increment_main_room_danger():
	if not player_spawn_point:
		return
	
	var start := player_spawn_point
	var base_danger := map.get_danger_level(start.x, start.y) + 1
	
	var current: Vector2
	var frontier := []
	var distance_from_spawn := {}
	var new_distance: int
	
	frontier.push_back(start)
	
	distance_from_spawn[start] = 0
	
	while not frontier.size() == 0:
		current = frontier.pop_back()
		
		for next in get_frontier_neighbors(current):
			
			new_distance = distance_from_spawn[current] + DISTANCE_STEP
			
			if is_visitable(next) and ( not distance_from_spawn.has(next) or new_distance < distance_from_spawn[next] ):
				frontier.push_back(next)
				distance_from_spawn[next] = new_distance
				
				map.set_main(next.x, next.y, true)
				map.set_danger_level(next.x, next.y, base_danger + new_distance)
	
	for point in distance_from_spawn: # Inverte e ordina l'array in una sola elegante mossa
		points_by_distance[distance_from_spawn[point]] = point


func fetch_ladder_location():
	ladder_spawn_point = points_by_distance.values().pop_back()
	
	max_distance[MAX_DIST_INDEX.VALUE] = points_by_distance.keys().pop_back()
	max_distance[MAX_DIST_INDEX.LOCATION] = ladder_spawn_point


func fetch_and_flag_spawnpoints():
	fetch_ladder_location()


func check_botched_flag():
	if botched:
		print("---------------------------------------------BotchedGen---------------------------------------------")
		CAVE_HEIGHT += 5
		CAVE_WIDTH += 5
		emit_signal("reset_generation")
	else:
		emit_signal("generation_complete")


# Attraversa il tunnel con un algoritmo di flood fill e chiama una funzione su ogni cella. 
# Nella chiamata vanno messi gli argomenti da passare alla funzione puntata in un array,
# alla fine della quale verrà appeso il vettore coordinate.
# La funzione step andrà chiamata manualmente sulla prima cella.
# Se la funzione deve sapere a che iterazione si trova, c'è una variabile member fatta apposta.
# Le funzioni step dovranno ritornare true per chiamare l'early exit
func traverse_tunnel_and_call_func(start_cell: Vector2, function: String, vararg: Array):
	var current: Vector2
	var frontier := []
	var visited := []
	
	var early_exit := false
	
	frontier.push_back(start_cell)
	
	while not frontier.size() == 0:
		current = frontier.pop_back()
		for next in get_frontier_neighbors(current):
			if is_visitable(next) and not visited.has(next):
				frontier.push_back(next)
				visited.append(next)
				
				vararg.push_back(next)
				early_exit = callv(function, vararg)
				vararg.pop_back()
				
				if early_exit:
					return


func setup_map():
	print("\n\n|||||||||||||||||||||||||||||||||| GENERATION #%s BEGINS ||||||||||||||||||||||||||||||||||" % gen_num)
	gen_num += 1
	randomize()
	flush_old_data()
	initialize_empty_map()
	randomize_map()
	
	for i in NUMBER_OF_STEPS:
		cellular_automaton_step()
	
	identify_tunnels()
	evaluate_map()
	fetch_spawn_point()
	set_danger_level()
	increment_main_room_danger()
	fetch_and_flag_spawnpoints()
	check_botched_flag()
