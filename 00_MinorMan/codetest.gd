extends Node2D

func _ready():
	var cell
	
	while true:
		yield(get_tree().create_timer(2.0), "timeout")
		cell = MapGrid.new()
		cell.initialize_empty(1000, 1000)
