extends CaveGenerator

const ladder_scene = preload("res://levels/Ambient/LadderDown.tscn")

onready var tilemap = $YSort/Walls

func _ready():
	connect("generation_complete", self, "setup_level")
	connect("reset_generation", self, "setup_map")
	setup_map()


func mapgrid_to_world(point: Vector2):
	return (tilemap.map_to_world(point) + tilemap.cell_size * 0.5) * tilemap.scale.x


func spawn_player():
	var point_in_world = mapgrid_to_world(player_spawn_point)
	
	$YSort/Norman.position = point_in_world


func spawn_ladder():
	var ladder = ladder_scene.instance()
	ladder.position = mapgrid_to_world(ladder_spawn_point)
	$YSort.add_child(ladder, true)


func build_level():
	tilemap.build_map(map, CAVE_WIDTH, CAVE_HEIGHT)


func log_buffer_info():
	var log_file = File.new()
	
	log_file.open("user://gen_log.txt", File.WRITE)
	
	$CanvasLayer/LogContainer/ColorRect/ScrollContainer/Label.text = ""
	
	for line in buffer:
		log_file.store_string(line)
		$CanvasLayer/LogContainer/ColorRect/ScrollContainer/Label.text += line
	
	


func setup_level():
	build_level()
	spawn_player()
	spawn_ladder()
	
	buffer.append("\n§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§ It took " + str(gen_num) + " generations to build this map.\n")
	
	log_buffer_info()


func _input(event):
	if Input.is_action_just_pressed("test_input"):
		setup_map()
	if Input.is_action_just_pressed("show_log"):
		$CanvasLayer/LogContainer.visible = !$CanvasLayer/LogContainer.visible
