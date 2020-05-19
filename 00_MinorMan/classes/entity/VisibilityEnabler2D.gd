extends VisibilityEnabler2D

"""
Allora, se vedi che arranca inventate qulacosa per pausà i tick.
Altrimenti sticazzi.
Probabilmente pausà l'animazioni quando non in vista darà problemi
con le transizioni tra stati, quindi se vedi bug ricordate che già sapevi
il possibile intoppo. Continua così. Daje.
Cioè, il sopra vale se non pausi completamente i nodi come stai a fa.
Anche se sto misto de roba pausata e non me inquieta un pochino.

Tread carefully.
"""


func _on_VisibilityEnabler2D_screen_entered():
	set_owner_status(true)


func _on_VisibilityEnabler2D_screen_exited():
	set_owner_status(false)


func set_owner_status(value: bool):
	if not owner:
		return
	
	set_node_status(owner.get_node("StateMachine"), value)
	owner.get_node("Tick").paused = not value


func set_node_status(node: Node, value: bool):
	node.set_physics_process(value)
	node.set_process(value)
