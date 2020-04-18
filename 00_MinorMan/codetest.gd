extends Node2D

func _ready():
	var map
	var i = 100
	
	while true:
		yield(get_tree().create_timer(2.0), "timeout")
		i += 1
		map = MapGrid.new()
		map.initialize_empty(i, i)
		print(map.get_size())
