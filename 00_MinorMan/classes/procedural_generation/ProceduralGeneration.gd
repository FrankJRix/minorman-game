extends Node

const CAVE_WIDTH = 50
const CAVE_HEIGHT = 50
const INITIAL_RATIO = 0.6
const NEIGHBOURHOOD_TRESHOLD = 4
const NUMBER_OF_STEPS = 5

const TEST_TILE_SIZE = 16
const ROCK = 1
const FREE_SPACE = 0

var map := []
var previous_map := []
var neighbor_map := []
var tile

func _ready():
	randomize()
	initialize_map()
	read_map()


func initialize_map():
	map = []
	for i in CAVE_WIDTH:
		map.append([])
		for j in CAVE_HEIGHT:
			map[i].append(FREE_SPACE if randf() < INITIAL_RATIO else ROCK)
			if is_on_boundary(i, j):
				map[i][j] = ROCK


func count_neighbourhood(x, y):
	var count = 0
	if not is_on_boundary(x, y):
		count += previous_map[x-1][y-1] + previous_map[x-1][y] + previous_map[x-1][y+1] + previous_map[x][y-1] + previous_map[x][y+1] + previous_map[x+1][y-1] + previous_map[x+1][y] + previous_map[x+1][y+1]
	return int(count)


func is_on_boundary(x, y):
	return x == 0 or x == CAVE_WIDTH - 1 or y == 0 or y == CAVE_HEIGHT - 1


func evolve(x, y):
	if count_neighbourhood(x, y) >= NEIGHBOURHOOD_TRESHOLD:
		map[x][y] = ROCK
	else:
		map[x][y] = FREE_SPACE


func cellular_automaton_step():
	previous_map = map.duplicate(true)
	for i in range(1, CAVE_WIDTH - 1):
		for j in range(1, CAVE_HEIGHT - 1):
			evolve(i, j)


func read_map():
	for i in CAVE_WIDTH:
		for j in CAVE_HEIGHT:
			tile = ColorRect.new()
			tile.color = Color.white if map[i][j] == 0 else Color.darkslategray
			tile.rect_min_size = Vector2(TEST_TILE_SIZE, TEST_TILE_SIZE)
			tile.rect_global_position = Vector2(i * TEST_TILE_SIZE, j * TEST_TILE_SIZE)
			add_child(tile)


func clear_map():
	for child in get_children():
		child.queue_free()


func _input(event):
	if Input.is_action_just_pressed("test_input"):
		clear_map()
		for i in NUMBER_OF_STEPS:
			cellular_automaton_step()
		read_map()
