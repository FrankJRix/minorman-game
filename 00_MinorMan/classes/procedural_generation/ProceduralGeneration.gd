extends Node

const ladder_scene = preload("res://levels/Ambient/LadderDown.tscn")

onready var tilemap = $YSort/Walls
onready var floors = $Floor

var thread

func _ready():
	CaveGen.subscribe(self)
	CaveGen.setup_multithreaded()


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
	tilemap.build_map(CaveGen.map, CaveGen.CAVE_WIDTH, CaveGen.CAVE_HEIGHT)
	floors.build_map(CaveGen.CAVE_WIDTH, CaveGen.CAVE_HEIGHT)


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
		spawnino = pair[1].instance()
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


func _input(_event):
	if Input.is_action_just_pressed("show_log"):
		$CanvasLayer/LogContainer.visible = !$CanvasLayer/LogContainer.visible
