extends Node2D

func _ready():
	looping_call("print_A", ["lecose"])
	looping_call("print_B", ["le tante", "le cose"])
	looping_call("print_C", [])
	pass
#	var map
#	var i = 100
#	map = MapGrid.new()
#
#	var othermap
#
#	while true:
#		yield(get_tree().create_timer(2.0), "timeout")
#		i += 1
#
#
#		map.initialize_empty(i, i)
#		othermap = map.get_duplicate()
#		print(othermap.get_size())

func print_A(what: String, n: int):
	print("Qui printA.\n" + what + " " + str(n) + "\n\n")

func print_B(arg1: String, arg2: String, n: int):
	print("Qui printBBBBBBBBBBBBBBBBBBBBBBB.\n" + arg1 + " " + arg2 + " " + str(n) + "\n\n")

func print_C(n: int):
	print("Solo print.\n\n")

func looping_call(function: String, vararg: Array):
	for i in 4:
		vararg.push_back(i)
		callv(function, vararg)
		vararg.pop_back()
