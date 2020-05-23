extends Node

const ladder_scene = preload("res://levels/Ambient/LadderDown.tscn")
const spawn_placeholder := preload("res://classes/utilities/SpawnPlaceholder.tscn")

export var width := 100
export var height := 100

onready var tilemap = $YSort/Walls
onready var floors = $Floor
onready var minimap = $CanvasLayer/CenterContainer/ViewportContainer/Viewport/Minimap

var stray_cells := []
var CaveGen: CaveGenerator

signal loading_finished

func _ready():
	CaveGen = CaveGenerator.new()
	
	CaveGen.subscribe(self)
	CaveGen.provide_map(width, height)
	$YSort/Walls.connect("tile_mined", self, "handle_tile_mined")


func _physics_process(delta):
	$CanvasLayer/PosLabel.text = str(world_to_mapgrid($YSort/Norman.position))
	
	if $CanvasLayer/LogContainer.visible:
		scroll_generation_log()


func scroll_generation_log():
	if Input.is_action_pressed("move_north"):
		$CanvasLayer/LogContainer/ColorRect/ScrollContainer.scroll_vertical -= 10
	
	if Input.is_action_pressed("move_south"):
		$CanvasLayer/LogContainer/ColorRect/ScrollContainer.scroll_vertical += 10


func mapgrid_to_world(point: Vector2): # Da spostare nelle tilemap insieme world_to_mapgrid!
	return (tilemap.map_to_world(point) + tilemap.cell_size * 0.5) * tilemap.scale.x


func world_to_mapgrid(point: Vector2):
	return tilemap.world_to_map((point / tilemap.scale.x) - tilemap.cell_size * 0.5)


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
	CaveGen.thread.wait_to_finish()
	
	build_level()
	spawn_player()
	spawn_ladder()
	spawn_enemies()
	
	CaveGen.buffer.append("\n\n> It took " + str(CaveGen.gen_num) + " generations to build this map.\n")
	
	$CanvasLayer/LoddingScreen.hide()
	$LoddAnim.stop()
	$CanvasLayer/ExitLabel.text = str(CaveGen.ladder_spawn_point)
	
	$CanvasLayer/ExitLabel.show()
	$CanvasLayer/PosLabel.show()
	
	log_buffer_info()
	
	emit_signal("loading_finished")


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
	
