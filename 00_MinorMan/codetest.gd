extends Node2D

func _ready():
	var map
	var i = 100
	map = MapGrid.new()
	
	var othermap
	
	while true:
		yield(get_tree().create_timer(2.0), "timeout")
		i += 1
		
		
		map.initialize_empty(i, i)
		othermap = map.get_duplicate()
		print(othermap.get_size())
