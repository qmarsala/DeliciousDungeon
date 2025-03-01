class_name LevelGenerator
extends GameScene

@export var room_size: int = 480
@export var start_template: PackedScene
@export var end_template: PackedScene
@export var hall_template: PackedScene
@export var room_template: PackedScene
@export var hall_chance: float = .5

var directions: Array[Vector2] = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
var starting_direction: Vector2
var current_position: Vector2
var current_direction: Vector2
var turn_degrees: int = 90
var tile_positions: Array[Vector2] = []
var start_position: Vector2 = Vector2.ZERO
var end_position: Vector2 = Vector2.ZERO
var tile_count: int = 8
var path_count: int = 4
var secondary_path_min_tiles: int = 3
var turn_ratio = randf_range(0.15, .85)
var turn_spacing = 1
var tiles_without_turning = 0

func _ready() -> void:
	generate_floor(level)

func generate_floor(floor: int) -> void:
	var depth = floor - 1
	tile_count = min(15, tile_count + depth)
	if depth > 2:
		path_count = min(10, path_count + depth - 2)
	secondary_path_min_tiles = min(10, secondary_path_min_tiles + depth)
	generate_tile_positions()
	place_tiles()

func generate_tile_positions():
	starting_direction = directions.pick_random()
	for pc in path_count:
		current_direction = starting_direction
		current_position = start_position
		if pc > 0:
			current_position = tile_positions[randi_range(tile_count * .3, tile_count * .7)]
			next_position()
		for tc in tile_count:
			if tile_positions.has(current_position): 
				next_position(false)
				continue
			if (pc > 0 and tc > secondary_path_min_tiles and randf() < .5):
				break
			if pc < 1 and tc >= tile_count - 1:
				end_position = current_position
			tile_positions.append(current_position)
			next_position()

func next_position(turn_enabled: bool = true) -> void:
	var next_direction: Vector2 = current_direction
	if turn_enabled and tiles_without_turning >= turn_spacing and randf() <= turn_ratio:
		tiles_without_turning = 0
		turn()
	else:
		tiles_without_turning += 1
	current_position = (current_position + next_direction * room_size).snappedf(1)

func turn() -> void:
	turn_degrees *= -1
	current_direction = current_direction.rotated(deg_to_rad(turn_degrees))

func place_tiles():
	for pos in tile_positions:
		var template
		if pos.is_equal_approx(start_position):
			template = start_template
		elif pos.is_equal_approx(end_position): 
			template = end_template
		elif hall_chance <= randf():
			template = hall_template
		else:
			template = room_template
		var instance = template.instantiate() as Room
		instance.global_position = pos.snappedf(1)
		instance.init(room_size, tile_positions.filter(func (p:Vector2): return is_neighbor(p, pos)))
		add_child(instance)

func is_neighbor(p: Vector2, pos: Vector2):
	return p.snappedf(1).is_equal_approx(Vector2(pos.x - room_size, pos.y).snappedf(1))\
		or p.snappedf(1).is_equal_approx(Vector2(pos.x, pos.y - room_size).snappedf(1))\
		or p.snappedf(1).is_equal_approx(Vector2(pos.x + room_size, pos.y).snappedf(1))\
		or p.snappedf(1).is_equal_approx(Vector2(pos.x, pos.y + room_size).snappedf(1))
