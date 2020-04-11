extends CaveGenerator

onready var tilemap = $YSort/Walls

func _ready():
	setup_level()

func spawn_player():
	var point_on_map = fetch_spawn_point()
	var point_in_world = tilemap.map_to_world(point_on_map) * tilemap.scale.x
	
	$YSort/Norman.position = point_in_world


# Ovviamente qui c'è un bug. Perché i vicini che conto stanno sulla generazione precedente. Però il comportamento è interessante, 
# perché sembra introdurre un bias selettivo che aggiunge, piuttosto che togliere.
func fetch_spawn_point():
	var ideal_spawn: Vector2
	
	for i in CAVE_WIDTH:
		for j in CAVE_HEIGHT:
			if map[i][j]["tunnel_id"] == largest_tunnel["id"] and count_neighbourhood(i, j) == 0:
				ideal_spawn = Vector2(i, j)
				break
	
	if  not ideal_spawn:
		print("Could not find suitable spawn point.")
		setup_level()
	
	return ideal_spawn


func build_level():
	tilemap.build_map(map, CAVE_WIDTH, CAVE_HEIGHT)


func setup_level():
	setup_map()
	build_level()
	spawn_player()


func _input(event):
	if Input.is_action_just_pressed("test_input"):
		setup_level()
