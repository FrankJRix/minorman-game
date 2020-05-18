extends Node

class_name CaveGenerator

### SEZIONE GENERAZIONE

# Best thus far:
#const INITIAL_RATIO = 0.6
#const NEIGHBOURHOOD_TRESHOLD = 4
#const NUMBER_OF_STEPS = 5 or 6 (- step -> + squadrato; + step -> - area)

const RATIO = 0.6
const NEIGHBOURHOOD_TRESHOLD = 4
const NUMBER_OF_STEPS = 6

const MIN_TUNNEL_AREA = 3
const DISTANCE_STEP = 5 # for danger increment

var CAVE_WIDTH := 100
var CAVE_HEIGHT := 100

var buffer: Array = []

var map := MapGrid.new()
var previous_map: MapGrid

var botched := false
var minimum_cave_area: int
var suppressed_count := 0
var gen_num := 0

var max_distance := [0, Vector2()]
enum MAX_DIST_INDEX {VALUE, LOCATION}

enum SPAWN_ID {ZERO, PLAYER, EXIT, ENEMY, LOOT, MINERAL}
var player_spawn_point := Vector2()
var ladder_spawn_point := Vector2()

var wall_cells := []

var tunnels := {
	"0": { # l'indice è l'id
		"start": Vector2(),
		"area": 0,
		"base_danger": 1,
		"cells": []
	}
}

var main_index:int = 0

signal generation_complete

### SEZIONE POPOLAZIONE
const DEFAULT_DIFFICULTY_PATH = "res://classes/procedural_generation/DifficultyTiers/DifficultyClassesResources/d_classes/blank/blank_difficulty.tres"

var difficulty_class: Resource = null

var enemy_scenes_dict := {}
var loot_scenes_dict := {}


func subscribe(node: Node)-> void:
	connect("generation_complete", node, "setup_level", [], 1)


################ FUNZIONI GENERAZIONE


func flush_old_data()-> void:
	botched = false
	
	minimum_cave_area = int( floor( (CAVE_WIDTH * CAVE_HEIGHT) / 5 ) )
	
	suppressed_count = 0
	
	player_spawn_point = Vector2()
	ladder_spawn_point = Vector2()
	
	max_distance = [0, Vector2()]
	
	wall_cells = []
	
	temp = []
	
	tunnels = {
	"0": { # l'indice è l'id
		"start": Vector2(),
		"area": 0,
		"base_danger": 1,
		"cells": []
		}
	}
	
	main_index = 0


func initialize_empty_map()-> void:
	map.initialize_empty(CAVE_WIDTH, CAVE_HEIGHT)


func randomize_map()-> void:
	map.randomize_map(RATIO, current_seed)


func cellular_automaton_step()-> void:
	previous_map = map.get_duplicate()
	
	for i in (CAVE_WIDTH - 4):
		for j in (CAVE_HEIGHT - 4):
			evolve(i+2, j+2)


func evolve(i, j)-> void:
	map.set_rock_state(i, j, count_neighbourhood(i, j) >= NEIGHBOURHOOD_TRESHOLD)


func count_neighbourhood(i, j)-> int:
	var count := 0
	
	for x in [i - 1, i, i + 1]:
		for y in [j - 1, j, j + 1]:
			count += int( previous_map.is_state_rock(x, y) )
	
	count -= int( previous_map.is_state_rock(i, j) )
	
	return count


func count_neighbourhood_at_present(i, j)-> int:
	var count := 0
	
	for x in [i - 1, i, i + 1]:
		for y in [j - 1, j, j + 1]:
			count += int( map.is_state_rock(x, y) )
	count -= int( map.is_state_rock(i, j) )
	
	return count


func evaluate_map()-> void:
	var cave_area = 0
	
	for i in tunnels:
		cave_area += tunnels[i]["area"]
	
	if cave_area <= minimum_cave_area:
		buffer.append("\n<><><><><><><><><><><><><><><><><><><><><><> TOO SMALL <><><><><><><><><><><><><><><><><><><><><><>")
		botched = true
	
	buffer.append("\nTotal area: " + str(cave_area))


func identify_tunnels()-> void:
	var id = 0
	
	for i in CAVE_WIDTH:
		for j in CAVE_HEIGHT:
			if is_visitable(Vector2(i, j)) and is_not_visited(Vector2(i, j)):
				id += 1
				mark_tunnel(i, j, id)
	
	buffer.append("\n\nNumber of tunnels: " + str(id - suppressed_count))
	buffer.append("\nThe largest tunnel is #" + str(main_index) + ", with an area of: " + str(tunnels[str(main_index)]["area"]) + ".\n")


func mark_tunnel(i, j, id)-> void:
	map.set_tunnel_id(i, j, id)
	tunnels[str(id)] = {}
	
	var start = Vector2(i, j)
	tunnels[str(id)]["start"] = start
	
	tunnels[str(id)]["cells"] = traverse_tunnel_and_call_func(start, "mark_tunnel_step", [id])####################################################################################
	tunnels[str(id)]["area"] = len(tunnels[str(id)]["cells"])
	
	if tunnels[str(id)]["area"] <= MIN_TUNNEL_AREA:
		
		buffer.append("\n--------------------------L'area di " + str(id) + " era " + str(tunnels[str(id)]["area"]) + " e poi è stato")
		
		tunnels[str(id)]["area"] = 0
		suppressed_count += 1
		for cell in tunnels[str(id)]["cells"]:
			fill_tunnel_step(cell)
	
	if tunnels[str(id)]["area"] > tunnels[str(main_index)]["area"]:
		main_index = id
	
	buffer.append("\nTunnel #" + str(id) + " has an area of: " + str(tunnels[str(id)]["area"]) + ".")

# Template per tutte le funzioni step, ossia le funzioni da chiamare dentro a traverse_tunnel
# Il vettore delle coordinate va sempre alla fine!
# Deve ritornare false per non uscire dal loop
func mark_tunnel_step(id, coords)-> bool:
	map.set_tunnel_id(coords.x, coords.y, id)
	return false


func fill_tunnel_step(coords)-> void:
	map.set_empty_cell(coords.x, coords.y)
	map.set_rock_state(coords.x, coords.y, true)
	buffer.append("\n--------------------------------------------------ROCCIATO!")


func fix_walls()-> void:
	var sum_ns: int
	var sum_we: int
	
	var n_nbor: Vector2
	var s_nbor: Vector2
	var w_nbor: Vector2
	var e_nbor: Vector2
	
	for cell in wall_cells:
		sum_we = 0
		sum_ns = 0
		n_nbor = get_frontier_ns_neighbors(cell)[0]
		s_nbor = get_frontier_ns_neighbors(cell)[1]
		w_nbor = get_frontier_we_neighbors(cell)[0]
		e_nbor = get_frontier_we_neighbors(cell)[1]
		
		
		for neighbor in get_frontier_ns_neighbors(cell):
			sum_ns += int(map.is_state_rock(neighbor.x, neighbor.y))
		
		for neighbor in get_frontier_we_neighbors(cell):
			sum_we += int(map.is_state_rock(neighbor.x, neighbor.y))
		
		if sum_we == 0 and sum_ns == 1:
			if map.is_state_rock(n_nbor.x, n_nbor.y) and not map.is_wall(n_nbor.x, n_nbor.y):
				smooth_single_wall_cell(cell, n_nbor, s_nbor)
			
			elif map.is_state_rock(s_nbor.x, s_nbor.y) and not map.is_wall(s_nbor.x, s_nbor.y):
				smooth_single_wall_cell(cell, s_nbor, n_nbor)
		
		if sum_we == 1 and sum_ns == 0:
			if map.is_state_rock(w_nbor.x, w_nbor.y) and not map.is_wall(w_nbor.x, w_nbor.y):
				smooth_single_wall_cell(cell, w_nbor, e_nbor)
			
			elif map.is_state_rock(e_nbor.x, e_nbor.y) and not map.is_wall(e_nbor.x, e_nbor.y):
				smooth_single_wall_cell(cell, e_nbor, w_nbor)


func smooth_single_wall_cell(cell: Vector2, rock_neighbor: Vector2, empty_neighbor: Vector2)-> void:
	map.set_empty_cell(cell.x, cell.y)
	map.set_tunnel_id(cell.x, cell.y, map.get_tunnel_id(empty_neighbor.x, empty_neighbor.y))
	tunnels[str(map.get_tunnel_id(empty_neighbor.x, empty_neighbor.y))]["cells"].append(cell)
	
	map.set_wall(rock_neighbor.x, rock_neighbor.y, true)
	wall_cells.append(rock_neighbor)


func get_frontier_neighbors(point)-> Array:
	var x = point.x
	var y = point.y
	
	return [Vector2(x, y-1), Vector2(x, y+1), Vector2(x-1, y), Vector2(x+1, y)]


func get_frontier_ns_neighbors(point)-> Array:
	var x = point.x
	var y = point.y
	
	return [Vector2(x, y-1), Vector2(x, y+1)]


func get_frontier_we_neighbors(point)-> Array:
	var x = point.x
	var y = point.y
	
	return [Vector2(x-1, y), Vector2(x+1, y)]


func is_visitable(pos)-> bool:
	return not map.is_state_rock(pos.x, pos.y)


func is_not_visited(pos)-> bool: # Legacy
	return map.get_tunnel_id(pos.x, pos.y) == 0


func is_contiguous(pos, id)-> bool: # Legacy
	return map.get_tunnel_id(pos.x, pos.y) == id


func fetch_spawn_point()-> void:
	if botched:
		return
	
	var found := false
	
	for cell in tunnels[str(main_index)]["cells"]:
		found = fetch_player_spawn_step(cell)
		if found:
			break
	
	map.set_spawn_id(player_spawn_point.x, player_spawn_point.y, SPAWN_ID.PLAYER)
	
	if  not player_spawn_point:
		
		buffer.append("\n--------------------------------------Could not find suitable spawn point.---------------------------------------------------------")
		
		botched = true


func fetch_player_spawn_step(coords)-> bool:
	if count_neighbourhood_at_present(coords.x, coords.y) == 0:
		player_spawn_point = coords
		return true
	else:
		return false


func set_danger_level()-> void:
	if botched:
		return
	
	for tunnel_id in tunnels:
		
		if tunnel_id == str(main_index): # Quindi se è il main tunnel
			tunnels[tunnel_id]["base_danger"] = 0
			
			buffer.append("\n\nSto nel main:\n")
			buffer.append("start: " + str(tunnels[tunnel_id]["start"]) + "\n")
			buffer.append("area: " + str(tunnels[tunnel_id]["area"]) + "\n")
			buffer.append("base_danger: " + str(tunnels[tunnel_id]["base_danger"]) + "\n")
		
		elif not tunnels[tunnel_id]["area"] == 0 and not tunnel_id == str(main_index):
			
			tunnels[tunnel_id]["base_danger"] = max(0, map.MAX_DANGER_LEVEL - tunnels[tunnel_id]["area"])
			
			for cell in tunnels[tunnel_id]["cells"]:
				set_danger_step(tunnels[tunnel_id]["base_danger"], cell)
			
			buffer.append("\n\n" + str(tunnel_id) + ":\n")
			buffer.append("start: " + str(tunnels[tunnel_id]["start"]) + "\n")
			buffer.append("area: " + str(tunnels[tunnel_id]["area"]) + "\n")
			buffer.append("base_danger: " + str(tunnels[tunnel_id]["base_danger"]) + "\n")


func set_danger_step(danger, coords)-> void:
	map.set_danger_level(coords.x, coords.y, danger)


func increment_main_room_danger()-> void:
	if botched:
		return
	
	var start := player_spawn_point
	
	var current: Vector2
	var frontier := []
	var points_by_distance := {}
	var distance_from_spawn := {}
	var new_distance: int
	
	frontier.push_back(start)
	
	distance_from_spawn[start] = 0
	
	while not frontier.size() == 0:
		current = frontier.pop_front()
		
		for next in get_frontier_neighbors(current):
			
			new_distance = distance_from_spawn[current] + DISTANCE_STEP
			
			if is_visitable(next) and ( not distance_from_spawn.has(next) or new_distance < distance_from_spawn[next] ):
				frontier.push_back(next)
				distance_from_spawn[next] = new_distance
				
				map.set_main(next.x, next.y, true)
				map.set_danger_level(next.x, next.y, new_distance)
	
	for point in distance_from_spawn: # Inverte e ordina il dizionario in una sola elegante mossa
		points_by_distance[distance_from_spawn[point]] = point
	
	max_distance[MAX_DIST_INDEX.LOCATION] = points_by_distance.values().pop_back()
	max_distance[MAX_DIST_INDEX.VALUE] = points_by_distance.keys().pop_back()


func fetch_ladder_location()-> void:
	if botched:
		return
	
	ladder_spawn_point = max_distance[MAX_DIST_INDEX.LOCATION]
	map.set_spawn_id(ladder_spawn_point.x, ladder_spawn_point.y, SPAWN_ID.EXIT)
	
	buffer.append("\nCoordinate uscita: " + str(ladder_spawn_point) + "\nDistanza: " + str(max_distance[MAX_DIST_INDEX.VALUE]) + ".")


################################################################################################ ABORTED, trovata soluzione più easy.
################################################################################################ Andrà ristrutturata con calma.
# Attraversa il tunnel con un algoritmo di flood fill e chiama una funzione su ogni cella. 
# Nella chiamata vanno messi gli argomenti da passare alla funzione puntata in un array,
# alla fine della quale verrà appeso il vettore coordinate.
# La funzione step andrà chiamata manualmente sulla prima cella.
# Se la funzione deve sapere a che iterazione si trova, c'è una variabile member fatta apposta.
# Le funzioni step dovranno ritornare true per chiamare l'early exit
func traverse_tunnel_and_call_func(start_cell: Vector2, function: String, vararg: Array)-> Array:
	var current: Vector2
	var frontier := []
	var visited := []
	
	var early_exit := false
	
	frontier.push_back(start_cell)
	
	while not frontier.size() == 0:
		current = frontier.pop_front()
		for next in get_frontier_neighbors(current):
			
			if not is_visitable(next):
				map.set_wall(next.x, next.y, true)
				wall_cells.append(next)
			
			if is_visitable(next) and not visited.has(next):
				frontier.push_back(next)
				visited.append(next)
				
				vararg.push_back(next)
				early_exit = callv(function, vararg)
				vararg.pop_back()
				
				if early_exit:
					return []
	
	if len(visited) == 0:
		visited.append(start_cell)
	
	return visited.duplicate(true)


############### FUNZIONI POPOLAZIONE


func set_difficulty_class(tres_path: String)-> void:
	difficulty_class = load(tres_path)
	load_spawnables()


func load_spawnables()-> void:
	for tier in difficulty_class.tiers:
		
		for enemy in tier.enemies_list:
			enemy_scenes_dict[enemy.resource_name] = load(enemy.path_to_scene)
		
		for loot in tier.loot_list:
			loot_scenes_dict[loot.resource_name] = load(loot.path_to_scene)
	
	print("\nenemies loaded: ", enemy_scenes_dict, "\nloot loaded: ", loot_scenes_dict, "\n")


func manage_enemy_spawns()-> void:
	
	for tunnel_id in tunnels:
		
		if tunnel_id == str(main_index): # Quindi se è il main tunnel
			enemies_in_main_tunnel(tunnel_id)
		
		elif not tunnels[tunnel_id]["area"] == 0 and not tunnel_id == str(main_index):
			enemies_in_side_tunnel(tunnel_id)


func enemies_in_main_tunnel(id)-> void:
	var cells_by_tier := {}
	
	for tier in difficulty_class.main_tiers: 		# cioè potrei fa tutto co una mannata, usando un dizionario de contatori
		cells_by_tier[tier.resource_name] = []		# ma poi sarebbe veramente troppo criptico
		for cell in tunnels[id]["cells"]:
			if cell_danger_in_range(cell, tier):
				cells_by_tier[tier.resource_name].append(cell)
	
	var counter
	
	for tier in difficulty_class.main_tiers:
		counter = tier.step ######################### VEDI SOTTO
		for cell in cells_by_tier[tier.resource_name]:
			if counter <= 0:
				temp.append([cell, enemy_scenes_dict[tier.enemies_list[0].resource_name]])
				counter = tier.step
			counter -= 1


func cell_danger_in_range(cell, tier)-> bool:
	var lower_bound = tier.range_start * max_distance[MAX_DIST_INDEX.VALUE]
	var upper_bound = tier.range_end * max_distance[MAX_DIST_INDEX.VALUE]
	var cell_danger = map.get_danger_level(cell.x, cell.y)
	
	return cell_danger >= lower_bound and cell_danger < upper_bound

var temp := []
func enemies_in_side_tunnel(id)-> void:
	var found := false
	var base: int = tunnels[id]["base_danger"]
	
	var chosen_tier: Resource = null
	
	for tier in difficulty_class.tiers:
		if base >= tier.range_start and base < tier.range_end:
			chosen_tier = tier
			found = true
		if found:
			break
	
	if not found:
		print("Nessun tier per #" + id + ".")
		return
	
	var counter = chosen_tier.step ###################### SERVE UN PO' DI VARIAZIONE
	
	for cell in tunnels[id]["cells"]:################################################# IMPLEMENTAZIONE PROVVISORIA TESSSSSSSSST
		if counter <= 0:
			temp.append([cell, enemy_scenes_dict[chosen_tier.enemies_list[0].resource_name]])
			counter = chosen_tier.step
		counter -= 1############################################################################################################
	
	print("Il tier " + chosen_tier.resource_name + " va bene per #" + id + ".")


func manage_spawnpoints()-> void:
	if botched:
		return
	
	manage_enemy_spawns()


############## FUNZIONONA


func setup_map(_u)-> void:
	custom_randomizer()
	
	botched = true
	while botched:
		botched = false
		
		buffer.append("\n\n\n|||||||||||||||||||||||||||||||||| GENERATION #%s BEGINS ||||||||||||||||||||||||||||||||||" % gen_num)
		buffer.append("\nUsing: " + difficulty_class.resource_name + "\nSeed: " + str(current_seed) + ".\n")
		
		gen_num += 1
		
		flush_old_data()
		initialize_empty_map()
		randomize_map()
		
		for i in NUMBER_OF_STEPS:
			cellular_automaton_step()
		
		identify_tunnels()
		fix_walls()
		evaluate_map()
		
		fetch_spawn_point()
		set_danger_level()
		increment_main_room_danger()
		fetch_ladder_location()
		
		manage_spawnpoints()
		
		if botched:
			buffer.append("\n---------------------------------------------BotchedGen---------------------------------------------")
			
			CAVE_HEIGHT += 1
			CAVE_WIDTH += 1
	
	emit_signal("generation_complete")


var thread: Thread
func provide_map(width: int, height: int)-> void:
	current_seed = 0
	buffer = []
	gen_num = 0
	enemy_scenes_dict = {}
	loot_scenes_dict = {}
	
	CAVE_WIDTH = width
	CAVE_HEIGHT = height
	
	set_difficulty_class(DEFAULT_DIFFICULTY_PATH)
	thread = Thread.new()
	thread.start(self, "setup_map")


var current_seed: = 0
func custom_randomizer(given_seed: int = 0)-> void:
	if not current_seed:
		if given_seed:
			current_seed = given_seed
		else:
			randomize()
			current_seed = randi()
	
	seed(current_seed)
