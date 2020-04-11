extends CaveGenerator

onready var tilemap = $YSort/Walls

func _ready():
	setup_level()


func spawn_player():
	var point_on_map = fetch_spawn_point()
	var point_in_world = tilemap.map_to_world(point_on_map) * tilemap.scale.x
	
	$YSort/Norman.position = point_in_world


func build_cave_map():
	tilemap.build_map(map, CAVE_WIDTH, CAVE_HEIGHT)


func setup_level():
	setup_map()
	build_cave_map()
	spawn_player()


func _input(event):
	if Input.is_action_just_pressed("test_input"):
		setup_level()
