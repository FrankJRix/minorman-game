extends KinematicBody2D

class_name Entity

const WEST_TRESHOLD = PI * 7/8
const SW_TRESHOLD = PI * 5/8
const SOUTH_TRESHOLD = PI * 3/8
const SE_TRESHOLD = PI * 1/8
const EAST_TRESHOLD = PI * -1/8
const NE_TRESHOLD = PI * -3/8
const NORTH_TRESHOLD = PI * -5/8
const NW_TRESHOLD = PI * -7/8

enum SECTOR {WEST, SOUTHWEST, SOUTH, SOUTHEAST, EAST, NORTHEAST, NORTH, NORTHWEST}
enum DIRECTION_MODE {EIGHT, FOUR}

func check_orientation_sector(angle):
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


func look_at_sector_w_anim(sector, animation, direction_mode = DIRECTION_MODE.EIGHT):
	match direction_mode:
		DIRECTION_MODE.EIGHT:
			look_eight(sector, animation)
		DIRECTION_MODE.FOUR:
			look_four(sector, animation)


func look_eight(sector, animation):
	match sector:
		SECTOR.WEST:
			$SpriteSheetAnim.play(animation + "_west")
		SECTOR.SOUTHWEST:
			$SpriteSheetAnim.play(animation + "_sw")
		SECTOR.SOUTH:
			$SpriteSheetAnim.play(animation + "_south")
		SECTOR.SOUTHEAST:
			$SpriteSheetAnim.play(animation + "_se")
		SECTOR.EAST:
			$SpriteSheetAnim.play(animation + "_east")
		SECTOR.NORTHEAST:
			$SpriteSheetAnim.play(animation + "_ne")
		SECTOR.NORTH:
			$SpriteSheetAnim.play(animation + "_north")
		SECTOR.NORTHWEST:
			$SpriteSheetAnim.play(animation + "_nw")


func look_four(sector, animation):
	match sector:
		SECTOR.WEST:
			$SpriteSheetAnim.play(animation + "_west")
		SECTOR.SOUTHWEST:
			$SpriteSheetAnim.play(animation + "_south")
		SECTOR.SOUTH:
			$SpriteSheetAnim.play(animation + "_south")
		SECTOR.SOUTHEAST:
			$SpriteSheetAnim.play(animation + "_east")
		SECTOR.EAST:
			$SpriteSheetAnim.play(animation + "_east")
		SECTOR.NORTHEAST:
			$SpriteSheetAnim.play(animation + "_north")
		SECTOR.NORTH:
			$SpriteSheetAnim.play(animation + "_north")
		SECTOR.NORTHWEST:
			$SpriteSheetAnim.play(animation + "_west")


func take_damage(attacker, amount=1, effect=null):
	if self.is_a_parent_of(attacker):
		return
	if self.has_node("States/Stagger"):
		$States/Stagger.knockback_direction = (attacker.global_position - global_position).normalized() # è un'idea, da valutare
	$Health.take_damage(amount, effect) # da inserire, eventualmente nella classe Entity


func set_dead(value):
	set_process_input(not value)
	set_physics_process(not value)
	$CollisionShape2D.disabled = value
