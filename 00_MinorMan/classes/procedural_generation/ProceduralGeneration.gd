extends CaveGenerator

onready var tilemap = $YSort/Walls

func _ready():
	connect("generation_complete", self, "setup_level")
	connect("reset_generation", self, "setup_map")
	setup_map()


func spawn_player():
	var point_on_map = fetch_spawn_point()
	var point_in_world = (tilemap.map_to_world(point_on_map) + tilemap.cell_size * 0.5) * tilemap.scale.x
	
	$YSort/Norman.position = point_in_world


func build_level():
	tilemap.build_map(map, CAVE_WIDTH, CAVE_HEIGHT)


func setup_level():
	build_level()
	spawn_player()


func _input(event):
	if Input.is_action_just_pressed("test_input"):
		setup_map()
