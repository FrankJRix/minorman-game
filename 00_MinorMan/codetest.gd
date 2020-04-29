extends Node2D

export (Resource) var resoo

func _ready():
#	looping_call("print_A", ["lecose"])
#	looping_call("print_B", ["le tante", "le cose"])
#	looping_call("print_C", [])
#	randomize()
#	var found = false
#
#	for i in 30:
#		found = false
#		var num = floor(rand_range(0, 80))
#		print("%s è in one(<%s), two(<%s) o three(<%s)" % [num, resoo.data[0].end, resoo.data[1].end, resoo.data[2].end])
#		for element in resoo.data:
#			if num <= element.end:
#				found = true
#				for string in element.enemies_list:
#					print(string + "  lol\n")
#				print("\n")
#				for string in element.loot_list:
#					print(string + "  lol loot\n")
#				break
#		if not found:
#			print("some default")
#		print("\n\n")
#	var matrice := Basis()
#	matrice.x = Vector3(1,2,3)
#	matrice.y = Vector3(4,5,6)
#	matrice.z = Vector3(7,8,9)
#
#	print(matrice[1][1])
	
#	var coso = Spawnable.new()
#	coso.max_instances = 5
#	coso.limited = true
#
#	print("da un massimo di ", coso.max_instances, " esemplari")
#
#	for i in 10:
#		print("ce ne stanno ancora ", coso.max_instances, " quindi available è ", coso.available)
#		coso.max_instances -= 1
#		if not coso.available:
#			break
	
	
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
	pass


func print_A(what: String, n: int):
	print("Qui printA.\n" + what + " " + str(n) + "\n\n")

func print_B(arg1: String, arg2: String, n: int):
	print("Qui printBBBBBBBBBBBBBBBBBBBBBBB.\n" + arg1 + " " + arg2 + " " + str(n) + "\n\n")

func print_C(n: int):
	print("Solo print.\n\n" + str(n))

func looping_call(function: String, vararg: Array):
	for i in 4:
		vararg.push_back(i)
		callv(function, vararg)
		vararg.pop_back()
