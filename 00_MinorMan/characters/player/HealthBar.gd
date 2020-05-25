extends ItemList

const FULL_HEART_TEXTURE = "res://placeholder_assets/GUI/HUD/Hearts1.png"
const HALF_HEART_TEXTURE = "res://placeholder_assets/GUI/HUD/Hearts2.png"


func update_health(current_health: int):
	var hearts := current_health / 2
	
	clear()
	for i in hearts:
		add_icon_item(load(FULL_HEART_TEXTURE), false)
	
	if current_health % 2:
		add_icon_item(load(HALF_HEART_TEXTURE), false)
