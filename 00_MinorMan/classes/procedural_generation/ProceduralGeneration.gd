extends Node

const ladder_scene = preload("res://levels/Ambient/LadderDown.tscn")
const spawn_placeholder := preload("res://classes/utilities/SpawnPlaceholder.tscn")

export var width := 100
export var height := 100

onready var tilemap = $YSort/Walls
onready var floors = $Floor
onready var minimap = $CanvasLayer/CenterContainer/ViewportContainer/Viewport/Minimap

var stray_cells := []

func _ready():
	CaveGen.subscribe(self)
	CaveGen.provide_map(width, height)
	$YSort/Walls.connect("tile_mined", self, "handle_tile_mined")


func mapgrid_to_world(point: Vector2):
	return (tilemap.map_to_world(point) + tilemap.cell_size * 0.5) * tilemap.scale.x


func spawn_player():
	var point_in_world = mapgrid_to_world(CaveGen.player_spawn_point)
	
	$YSort/Norman.position = point_in_world


func spawn_ladder():
	var ladder = ladder_scene.instance()
	ladder.position = mapgrid_to_world(CaveGen.ladder_spawn_point)
	$YSort.add_child(ladder, true)


func build_level():
	tilemap.build_map(CaveGen.map)
	floors.build_map(CaveGen.map)


func log_buffer_info():
	var log_file = File.new()
	
	log_file.open("user://%s_generation_log.txt" % CaveGen.current_seed, File.WRITE)
	
	$CanvasLayer/LogContainer/ColorRect/ScrollContainer/Label.text = ""
	
	for line in CaveGen.buffer:
		log_file.store_string(line)
		$CanvasLayer/LogContainer/ColorRect/ScrollContainer/Label.text += line


# Qui il gioco sarebbe faje piazzà un placehoder che spawna la bestiola quando entra a schermo,
# perché così soffre un botto per tutti i timer.
func spawn_enemies():
	############################################################################# SUPERBETA
	var spawnino
	for pair in CaveGen.temp:
		spawnino = spawn_placeholder.instance()
		spawnino.spawn_target = pair[1]
		spawnino.position = mapgrid_to_world(pair[0])
		$YSort/Enemies.add_child(spawnino, true)
	#############################################################################


func setup_level():
	build_level()
	spawn_player()
	spawn_ladder()
	spawn_enemies()
	
	CaveGen.buffer.append("\n\n> It took " + str(CaveGen.gen_num) + " generations to build this map.\n")
	
	$CanvasLayer/LoddingScreen.hide()
	$LoddAnim.stop()
	
	log_buffer_info()


func handle_tile_mined(tile_pos):
	if CaveGen.map.is_on_boundary(tile_pos.x, tile_pos.y) or not CaveGen.map.is_state_rock(tile_pos.x, tile_pos.y):
		return
	
	CaveGen.map.set_rock_state(tile_pos.x, tile_pos.y, false)
	stray_cells.append(tile_pos)
	
	tilemap.update_mined_tiles(tile_pos)
	minimap.update_mined_tiles(tile_pos)


func _input(_event):
	if Input.is_action_just_pressed("show_log"):
		$CanvasLayer/LogContainer.visible = !$CanvasLayer/LogContainer.visible
