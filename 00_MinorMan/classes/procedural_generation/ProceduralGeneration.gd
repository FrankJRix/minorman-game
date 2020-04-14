extends CaveGenerator

onready var tilemap = $YSort/Walls

func _ready():
	setup_level()


func evaluate_level():
	if botched:
		CAVE_HEIGHT += 5
		CAVE_WIDTH += 5
		setup_level()


func spawn_player():
	var point_on_map = fetch_spawn_point()
	var point_in_world = tilemap.map_to_world(point_on_map) * tilemap.scale.x
	
	$YSort/Norman.position = point_in_world


func fetch_spawn_point():
	var ideal_spawn: Vector2
	
	for i in CAVE_WIDTH:
		for j in CAVE_HEIGHT:
			if map[i][j]["tunnel_id"] == largest_tunnel["id"] and count_neighbourhood_at_present(i, j) == 0:
				ideal_spawn = Vector2(i, j)
				break
	
	if  not ideal_spawn:
		print("--------------------------------------Could not find suitable spawn point.---------------------------------------------------------")
		botched = true
	
	return ideal_spawn


func build_level():
	tilemap.build_map(map, CAVE_WIDTH, CAVE_HEIGHT)


func setup_level():
	setup_map()
	build_level()
	spawn_player()
	evaluate_level()


func _input(event):
	if Input.is_action_just_pressed("test_input"):
		setup_level()
