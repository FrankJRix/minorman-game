extends Sprite

# estendere includendo danno?

export var display_name: String = "base_melee"
export var base_damage: int = 1
export var effect_list: Array = []

export (float, 0.0, 2.0) var cooldown := 0.2
export (float, 0.0, 2.0) var slowdown := 0.5

var can_swing := true

func _ready():
	$Cooldown.wait_time = cooldown


func _on_Area2D_area_entered(area):
	if not area.owner:
		print(area.name, " non è una hitbox!")
		return
	if area.owner.has_method("take_damage"):
		area.owner.take_damage(self)


func swing_hit(direction):
	$Cooldown.start()
	can_swing = false
	
	print($Cooldown.wait_time)
	
	$AnimationPlayer.stop()
	rotation = direction.angle() - PI / 2
	$AnimationPlayer.play("hit")


func _on_Area2D_body_entered(body):
	if body is TileMap and body.has_method("take_damage"):
		body.take_damage(self)


func _on_Cooldown_timeout():
	can_swing = true
