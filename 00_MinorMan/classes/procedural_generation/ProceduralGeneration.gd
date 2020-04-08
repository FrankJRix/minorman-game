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
var tile

var evaluation_color := Color.white

func _ready():
	randomize()
	initialize_map()
	#read_map()
	build_cave()


func initialize_map():
	map = []
	
	for i in CAVE_WIDTH:
		map.append([])
		for j in CAVE_HEIGHT:
			map[i].append(FREE_SPACE if randf() < INITIAL_RATIO else ROCK)
			if is_on_boundary(i, j):
				map[i][j] = ROCK


func count_neighbourhood(i, j):
	var count = 0
	if not is_on_boundary(i, j):
		count += previous_map[i-1][j-1] + previous_map[i-1][j] + previous_map[i-1][j+1] + previous_map[i][j-1] + previous_map[i][j+1] + previous_map[i+1][j-1] + previous_map[i+1][j] + previous_map[i+1][j+1]
	return int(count)


func is_on_boundary(i, j):
	return i == 0 or i == CAVE_WIDTH - 1 or j == 0 or j == CAVE_HEIGHT - 1


func evolve(i, j):
	if count_neighbourhood(i, j) >= NEIGHBOURHOOD_TRESHOLD:
		map[i][j] = ROCK
	else:
		map[i][j] = FREE_SPACE


func cellular_automaton_step():
	var i = 1
	
	previous_map = map.duplicate(true)
	
	for i in (CAVE_WIDTH - 2):
		for j in (CAVE_HEIGHT - 2):
			evolve(i+1, j+1)


func evaluate():
	var cave_area = 0
	
	for i in CAVE_WIDTH:
		for j in CAVE_HEIGHT:
			cave_area += map[i][j]
	
	cave_area = CAVE_WIDTH * CAVE_HEIGHT - cave_area
	
	evaluation_color = Color.white if cave_area > MINIMUM_CAVE_AREA else Color.red
	
	print(cave_area)


func read_map():
	for i in CAVE_WIDTH:
		for j in CAVE_HEIGHT:
			tile = ColorRect.new()
			tile.color = evaluation_color if map[i][j] == 0 else Color.darkslategray
			tile.rect_min_size = Vector2(TEST_TILE_SIZE, TEST_TILE_SIZE)
			tile.rect_global_position = Vector2(i * TEST_TILE_SIZE, j * TEST_TILE_SIZE)
			add_child(tile)


func build_cave():
	for i in CAVE_WIDTH:
		for j in CAVE_HEIGHT:
			tilemap.set_cell(i, j, map[i][j] - 1)
	tilemap.update_bitmask_region()


func clear_map():
	for child in get_children():
		child.queue_free()


func _input(event):
	if Input.is_action_just_pressed("test_input"):
		#clear_map()
		for i in NUMBER_OF_STEPS:
			cellular_automaton_step()
		evaluate()
		#read_map()
		build_cave()
