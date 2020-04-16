extends Node2D

func _ready():
	var cell
	
	while true:
		yield(get_tree().create_timer(2.0), "timeout")
		for i in 1000:
			cell = 0
			print(cell)
