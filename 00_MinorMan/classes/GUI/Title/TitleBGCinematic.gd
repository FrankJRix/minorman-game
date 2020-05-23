extends "res://classes/procedural_generation/ProceduralGeneration.gd"

const CAMERA_SPEED = 0.6
const BORDER_OFFSET = 20

var direction: Vector2

func _ready():
	randomize()
	direction = Vector2((randf() * 2) - 1, (randf() * 2) - 1).normalized()


func _process(delta):
	
	if camera_out_of_bound_n() and direction.y < 0:
		direction.y = -direction.y
	if camera_out_of_bound_s() and direction.y > 0:
		direction.y = -direction.y
	if camera_out_of_bound_w() and direction.x < 0:
		direction.x = -direction.x
	if camera_out_of_bound_e() and direction.x > 0:
		direction.x = -direction.x
	
	$Camera2D.position += direction * CAMERA_SPEED


func camera_out_of_bound_n():
	var pos = $Camera2D.position
	var tresh_n = mapgrid_to_world(Vector2(0, BORDER_OFFSET)).y
	return pos.y <= tresh_n


func camera_out_of_bound_s():
	var pos = $Camera2D.position
	var tresh_s = mapgrid_to_world(Vector2(0, height - BORDER_OFFSET)).y
	return pos.y >= tresh_s


func camera_out_of_bound_w():
	var pos = $Camera2D.position
	var tresh_w = mapgrid_to_world(Vector2(BORDER_OFFSET, 0)).x
	return pos.x <= tresh_w


func camera_out_of_bound_e():
	var pos = $Camera2D.position
	var tresh_e = mapgrid_to_world(Vector2(width - BORDER_OFFSET, 0)).x
	return pos.x >= tresh_e


func _on_TitleBGCinematic_loading_finished():
	var camera_pos: Vector2
	camera_pos.x = clamp(CaveGen.player_spawn_point.x, BORDER_OFFSET, width - BORDER_OFFSET)
	camera_pos.y = clamp(CaveGen.player_spawn_point.y, BORDER_OFFSET, height - BORDER_OFFSET)
	
	$Camera2D.position = mapgrid_to_world(camera_pos)
