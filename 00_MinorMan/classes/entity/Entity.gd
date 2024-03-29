extends KinematicBody2D

class_name Entity

enum DIRECTION_MODE {TWO = 2, FOUR = 4, EIGHT = 8}

# Eight directions constants:
enum SECTOR {WEST, SOUTHWEST, SOUTH, SOUTHEAST, EAST, NORTHEAST, NORTH, NORTHWEST}

const WEST_TRESHOLD = PI * 7/8
const SW_TRESHOLD = PI * 5/8
const SOUTH_TRESHOLD = PI * 3/8
const SE_TRESHOLD = PI * 1/8
const EAST_TRESHOLD = PI * -1/8
const NE_TRESHOLD = PI * -3/8
const NORTH_TRESHOLD = PI * -5/8
const NW_TRESHOLD = PI * -7/8

# Four directions constants:
enum SECTOR_FOUR {WEST, SOUTH, EAST, NORTH}

const WEST_TRESHOLD_F = PI * 3/4
const SOUTH_TRESHOLD_F = PI * 1/4
const EAST_TRESHOLD_F = PI * -1/4
const NORTH_TRESHOLD_F = PI * -3/4

# Two directions constants:
enum SIDE {LEFT, RIGHT}

const LEFT_TRESHOLD = PI * 1/2
const RIGHT_TRESHOLD = PI * -1/2
################################

signal tick

export (float, 0.0, 10.0) var kb_modifier := 1.0

var knockback_vector := Vector2()
var kb_damp := 0.25 # Sarebbe da farlo legge dal terreno.

var last_facing_direction := Vector2.DOWN

var trail: Array = []

func _ready():
	if self.has_node("Health"):
		$Health.connect("health_depleted", self, "die")
	else:
		print("Questa Entity non ha Health: ", self.name)
	
	$Tick.connect("timeout", self, "_emit_tick")
	add_to_appropriate_faction()


func add_to_appropriate_faction():
	add_to_group(Data.factions["neutral"])


func _emit_tick():
	emit_signal("tick")


func _physics_process(delta):
	knockback_vector = knockback_vector.linear_interpolate(Vector2(), kb_damp)


func take_damage(attacker: Node, amount: int, knockback: int, effect_list: Array):
	if self.is_a_parent_of(attacker):
		return
	
	knockback_vector = (attacker.global_position - global_position).normalized() * kb_modifier * knockback
	
	$Health.take_damage(amount, effect_list) # da inserire
	print(self.name, " è stato colpito da ", attacker.owner.name, "!")


func move_with_knockback(linear_velocity: Vector2, 
						up_direction: Vector2 = Vector2( 0, 0 ), 
						stop_on_slope: bool = false, 
						max_slides: int = 4, 
						floor_max_angle: float = 0.785398, 
						infinite_inertia: bool = true)-> Vector2:
	
	if linear_velocity:
		last_facing_direction = linear_velocity.normalized()
	
	return move_and_slide(linear_velocity - knockback_vector, up_direction, stop_on_slope, max_slides, floor_max_angle, infinite_inertia)


func die():
	set_dead(true)
	queue_free()


func set_dead(value):
	set_process_input(not value)
	set_physics_process(not value)
	$CollisionShape2D.set_deferred("disabled", value)


func look_at_w_anim(point: Vector2, animation: String, direction_mode: int = DIRECTION_MODE.EIGHT, cutout_flag: bool = false):
	
	match direction_mode:
		DIRECTION_MODE.EIGHT:
			look_eight(check_orientation_sector(point), animation, cutout_flag)
		DIRECTION_MODE.FOUR:
			look_four(check_orientation_sector_four(point), animation, cutout_flag)
		DIRECTION_MODE.TWO:
			look_two(check_side(point), animation, cutout_flag)


func check_orientation_sector(point: Vector2):
	var angle = point.angle()
	var sector
	
	if angle >= WEST_TRESHOLD:
		sector = SECTOR.WEST
	elif angle >= SW_TRESHOLD:
		sector = SECTOR.SOUTHWEST
	elif angle >= SOUTH_TRESHOLD:
		sector = SECTOR.SOUTH
	elif angle >= SE_TRESHOLD:
		sector = SECTOR.SOUTHEAST
	elif angle >= EAST_TRESHOLD:
		sector = SECTOR.EAST
	elif angle >= NE_TRESHOLD:
		sector = SECTOR.NORTHEAST
	elif angle >= NORTH_TRESHOLD:
		sector = SECTOR.NORTH
	elif angle >= NW_TRESHOLD:
		sector = SECTOR.NORTHWEST
	else:
		sector = SECTOR.WEST
	
	return sector


func check_orientation_sector_four(point: Vector2):
	var angle = point.angle()
	var sector
	
	if angle >= WEST_TRESHOLD_F:
		sector = SECTOR_FOUR.WEST
	
	elif angle >= SOUTH_TRESHOLD_F:
		sector = SECTOR_FOUR.SOUTH
	
	elif angle >= EAST_TRESHOLD_F:
		sector = SECTOR_FOUR.EAST
	
	elif angle >= NORTH_TRESHOLD_F:
		sector = SECTOR_FOUR.NORTH
	
	else:
		sector = SECTOR_FOUR.WEST
	
	return sector


func check_side(point: Vector2):
	var angle = point.angle()
	var side
	
	if angle >= LEFT_TRESHOLD:
		side = SIDE.LEFT
	elif angle >= RIGHT_TRESHOLD:
		side = SIDE.RIGHT
	else:
		side = SIDE.LEFT
	
	return side


func look_eight(sector, animation, cutout_flag):
	match sector:
		SECTOR.WEST:
			$SpriteSheetAnim.play(animation + "_sw")
			if cutout_flag: $CutoutAnim.play(animation + "_sw")
		SECTOR.SOUTHWEST:
			$SpriteSheetAnim.play(animation + "_sw")
			if cutout_flag: $CutoutAnim.play(animation + "_sw")
		SECTOR.SOUTH:
			$SpriteSheetAnim.play(animation + "_south")
			if cutout_flag: $CutoutAnim.play(animation + "_south")
		SECTOR.SOUTHEAST:
			$SpriteSheetAnim.play(animation + "_se")
			if cutout_flag: $CutoutAnim.play(animation + "_se")
		SECTOR.EAST:
			$SpriteSheetAnim.play(animation + "_se")
			if cutout_flag: $CutoutAnim.play(animation + "_se")
		SECTOR.NORTHEAST:
			$SpriteSheetAnim.play(animation + "_ne")
			if cutout_flag: $CutoutAnim.play(animation + "_ne")
		SECTOR.NORTH:
			$SpriteSheetAnim.play(animation + "_north")
			if cutout_flag: $CutoutAnim.play(animation + "_north")
		SECTOR.NORTHWEST:
			$SpriteSheetAnim.play(animation + "_nw")
			if cutout_flag: $CutoutAnim.play(animation + "_nw")


func look_four(sector, animation, cutout_flag):
	match sector:
		SECTOR_FOUR.WEST:
			$SpriteSheetAnim.play(animation + "_west")
			if cutout_flag: $CutoutAnim.play(animation + "_west")
		
		SECTOR_FOUR.SOUTH:
			$SpriteSheetAnim.play(animation + "_south")
			if cutout_flag: $CutoutAnim.play(animation + "_south")
		
		SECTOR_FOUR.EAST:
			$SpriteSheetAnim.play(animation + "_east")
			if cutout_flag: $CutoutAnim.play(animation + "_east")
		
		SECTOR_FOUR.NORTH:
			$SpriteSheetAnim.play(animation + "_north")
			if cutout_flag: $CutoutAnim.play(animation + "_north")


func look_two(side, animation, cutout_flag):
	match side:
		SIDE.LEFT:
			$SpriteSheetAnim.play(animation + "_left")
			if cutout_flag: $CutoutAnim.play(animation + "_left")
		SIDE.RIGHT:
			$SpriteSheetAnim.play(animation + "_right")
			if cutout_flag: $CutoutAnim.play(animation + "_right")
