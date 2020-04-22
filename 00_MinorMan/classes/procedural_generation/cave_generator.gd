extends Node

class_name CaveGenerator

# Best thus far:
#const INITIAL_RATIO = 0.6
#const NEIGHBOURHOOD_TRESHOLD = 4
#const NUMBER_OF_STEPS = 5 or 6 (- step -> + squadrato; + step -> - area)

const RATIO = 0.6
const NEIGHBOURHOOD_TRESHOLD = 4
const NUMBER_OF_STEPS = 6

const MINIMUM_CAVE_AREA = 750
const MIN_TUNNEL_AREA = 3

enum SPAWN_ID {PLAYER, ENEMY, LOOT}

export var CAVE_WIDTH := 54
export var CAVE_HEIGHT := 54

var map := MapGrid.new()
var previous_map: MapGrid
var botched := false
var suppressed_count := 0
var player_spawn_point := Vector2()
var tunnel_iterator_step_counter := 1

var tunnels := {
	0: { # l'indice è l'id
		"start": Vector2(),
		"area": 0
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
	
	suppressed_count = 0
	
	player_spawn_point = Vector2()
	
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
	
	if cave_area == 0:
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
	print(tunnels)


func mark_tunnel(i, j, id):
	map.set_tunnel_id(i, j, id)
	tunnels[str(id)] = {}
	
	var start = Vector2(i, j)
	tunnels[str(id)]["start"] = start
	tunnels[str(id)]["area"] = 1
	
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


func is_not_visited(pos): # Legacy
	return map.get_tunnel_id(pos.x, pos.y) == 0


func is_contiguous(pos, id): # ?
	return map.get_tunnel_id(pos.x, pos.y) == id


# Priorità è sistemare questa, che non deve ritornare niente ma piazzare la flag per la generazione nella mappa. Rifare tutto il sistema di spawning. 
func fetch_spawn_point():# Legacy
	var start = largest_tunnel["start"]
	
	traverse_tunnel_and_call_func(start, "fetch_player_spawn_step", [])
	
	if  not player_spawn_point:
		print("--------------------------------------Could not find suitable spawn point.---------------------------------------------------------")
		botched = true


func fetch_player_spawn_step(coords):
	if count_neighbourhood_at_present(coords.x, coords.y) == 0:
		player_spawn_point = coords
		return true
	else:
		return false


func set_spawn_flags():
	pass


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
	
	# Questa probabilmente non serve in realtà. Per ora rinvio il giudizio.
	tunnel_iterator_step_counter = 1 # questa andrà usata dentro il ciclo, e incrementata prima della chiamata 
									 # (per tener conto del fatto che si salta la prima casella)
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
	randomize()
	flush_old_data()
	initialize_empty_map()
	randomize_map()
	for i in NUMBER_OF_STEPS:
		cellular_automaton_step()
	identify_tunnels()
	evaluate_map()
	fetch_spawn_point()
	check_botched_flag()
