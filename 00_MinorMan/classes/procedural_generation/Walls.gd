extends TileMap

signal tile_mined(pos)

func build_map(map: MapGrid):
	write_minimap(map)
	
	for i in map.get_size().x:
		for j in map.get_size().y:
			if map.is_state_rock(i,j):
				set_cell(i, j, int( map.noise_map.get_noise_2d(i, j) > 0.3 ))
	
	update_bitmask_region()


func write_minimap(current_map):
	get_tree().call_group("GUI", "update_minimap", current_map)


func take_damage(attacker):
	var hit_offset = Vector2(cos(attacker.rotation + PI/2), sin(attacker.rotation + PI/2)) * 80
	hit_offset += Vector2.DOWN * 80
	var hit_tile_position = hit_offset + attacker.global_position
	var point = world_to_map(hit_tile_position / scale)
	
	emit_signal("tile_mined", point)


func update_mined_tiles(point):
	set_cellv(point, -1)
	
	update_bitmask_area(point)
	update_dirty_quadrants()
