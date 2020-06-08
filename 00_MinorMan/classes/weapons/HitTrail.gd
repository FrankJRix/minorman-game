extends Sprite

const KNOCKBACK_VALUE = 2500

export var display_name: String = "weapon_template"
export var base_damage: int = 1
export (float, 0.0, 5.0) var base_knockback: float = 1.0
export var effect_list: Array = []

export (float, 0.0, 2.0) var cooldown := 0.2
export (float, 0.0, 2.0) var slowdown := 0.5

var can_swing := true
var wielder: Node # da implementare, riferimento a chi la impugna per vedere gli effetti di stato

func _ready():
	$Cooldown.wait_time = cooldown


func _on_Area2D_area_entered(area):
	if not area.owner:
		print(area.name, " non è una hitbox!")
		return
	if area.owner.has_method("take_damage"):
		area.owner.take_damage(self, base_damage, base_knockback * KNOCKBACK_VALUE, effect_list)


func swing_hit(direction):
	$Cooldown.start()
	can_swing = false
	
	$AnimationPlayer.stop()
	rotation = direction.angle() - PI / 2
	$AnimationPlayer.play("hit")


func _on_Area2D_body_entered(body):
	if body is TileMap and body.has_method("take_damage"):
		body.take_damage(self)


func _on_Cooldown_timeout():
	can_swing = true
