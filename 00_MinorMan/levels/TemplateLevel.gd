extends Location

func _ready():
	if OS.get_name() == "Android":
		GlobalDebug.show_touch_joypad()
