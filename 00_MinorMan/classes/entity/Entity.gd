extends KinematicBody2D

class_name Entity

enum DIRECTION_MODE {EIGHT, FOUR, TWO}

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

var knockback := Vector2()
var kb_intensity := 2500
var kb_damp := 0.25

func _ready():
	if self.has_node("Health"):
		$Health.connect("health_depleted", self, "die")
	else:
		print("Questa Entity non ha Health: ", self.name)


func _physics_process(delta):
	knockback = knockback.linear_interpolate(Vector2(), kb_damp)


func take_damage(attacker, amount=1, effect=null):
	if self.is_a_parent_of(attacker):
		return
	
	knockback = (attacker.global_position - global_position).normalized() * kb_intensity * amount
	
	$Health.take_damage(amount, effect) # da inserire
	print(self.name, " è stato colpito da ", attacker.owner.name, "!")


func move_with_knockback(linear_velocity: Vector2, 
					up_direction: Vector2 = Vector2( 0, 0 ), 
					stop_on_slope: bool = false, 
					max_slides: int = 4, 
					floor_max_angle: float = 0.785398, 
					infinite_inertia: bool = true)-> Vector2:
	
	return move_and_slide(linear_velocity - knockback, up_direction, stop_on_slope, max_slides, floor_max_angle, infinite_inertia)


func die():
	set_dead(true)
	queue_free()


func set_dead(value):
	set_process_input(not value)
	set_physics_process(not value)
	$CollisionShape2D.set_deferred("disabled", value)


func look_at_w_anim(point: Vector2, animation: String, direction_mode = DIRECTION_MODE.EIGHT):
	
	match direction_mode:
		DIRECTION_MODE.EIGHT:
			look_eight(check_orientation_sector(point), animation)
		DIRECTION_MODE.FOUR:
			look_four(check_orientation_sector_four(point), animation)
		DIRECTION_MODE.TWO:
			look_two(check_side(point), animation)


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


func look_eight(sector, animation):
	match sector:
		SECTOR.WEST:
			$SpriteSheetAnim.play(animation + "_sw")
		SECTOR.SOUTHWEST:
			$SpriteSheetAnim.play(animation + "_sw")
		SECTOR.SOUTH:
			$SpriteSheetAnim.play(animation + "_south")
		SECTOR.SOUTHEAST:
			$SpriteSheetAnim.play(animation + "_se")
		SECTOR.EAST:
			$SpriteSheetAnim.play(animation + "_se")
		SECTOR.NORTHEAST:
			$SpriteSheetAnim.play(animation + "_ne")
		SECTOR.NORTH:
			$SpriteSheetAnim.play(animation + "_north")
		SECTOR.NORTHWEST:
			$SpriteSheetAnim.play(animation + "_nw")


func look_four(sector, animation):
	match sector:
		SECTOR_FOUR.WEST:
			$SpriteSheetAnim.play(animation + "_west")
		
		SECTOR_FOUR.SOUTH:
			$SpriteSheetAnim.play(animation + "_south")
		
		SECTOR_FOUR.EAST:
			$SpriteSheetAnim.play(animation + "_east")
		
		SECTOR_FOUR.NORTH:
			$SpriteSheetAnim.play(animation + "_north")


func look_two(side, animation):
	match side:
		SIDE.LEFT:
			$SpriteSheetAnim.play(animation + "_left")
		SIDE.RIGHT:
			$SpriteSheetAnim.play(animation + "_right")
