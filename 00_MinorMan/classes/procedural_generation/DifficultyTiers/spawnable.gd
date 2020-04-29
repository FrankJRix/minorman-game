extends Resource

class_name Spawnable

export (String) var path_to_scene = "patthocoldiavolo"
export (int, 0, 100) var weight = 1

# Attento che queste potrebbero risultà globali
export (bool) var limited = false
export (int, 0, 100) var max_instances = 0 setget set_max_instances

export (bool) var mandatory = false

export (bool) var multicell = false
export (Basis) var shape = Basis() # da usare con if neighbors[i][j] and basis[i][j] (se entrambe settate c'è collisione)

export (bool) var boss = false # tentativo per limitare certe cose room-wise

var available := true


func set_max_instances(value):
	if limited and max_instances <= 0:
		available = false
		return
	max_instances = value
