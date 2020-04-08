extends KinematicBody2D

var n = 0

func take_damage(_attacker):
	n += 1
	print("AHIA CAZZO " + str(n))
