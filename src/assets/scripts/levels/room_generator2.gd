class_name RoomGenerator2
extends Node2D

@export var room_size: int = 320

@export var start_template: PackedScene
@export var end_template: PackedScene
@export var room_templates: Array[PackedScene]

var directions: Array[Vector2] = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
var can_turn_right: bool = true
var tile_positions: Array[Vector2] = []
var start_position: Vector2 = Vector2.ZERO
var end_position: Vector2 = Vector2.ZERO

# todo: increase with dungeon floor
var path_count: int = 10
var tile_count: int = 10
var branch_size: int = 10

#func _ready() -> void:
func generate_floor(floor: int) -> void:
	generate_tile_positions()
	place_tiles()

func generate_tile_positions():
	for pc in path_count:
		var direction = directions.pick_random()
		var turn_ratio = randf_range(0.15, .85)
		var current_position = start_position
		if pc > 0:
			current_position = tile_positions[randi_range(tile_count * .3, tile_count * .7)] + direction * room_size
		for tc in tile_count:
			var pos = current_position.snappedf(1)
			if tile_positions.has(pos): 
				print('skipping!')
				current_position += direction * room_size
				continue
			if (pc > 0 and tc > branch_size):
				break
			tile_positions.append(pos)
			if randf() < turn_ratio:
				direction = turn(direction)
			current_position += direction * room_size
			if tc >= tile_count - 1:
				end_position = current_position

func turn(direction: Vector2) -> Vector2:
	if can_turn_right:
		can_turn_right = false
		return direction.rotated(deg_to_rad(90))
	else:
		can_turn_right = true
		return direction.rotated(deg_to_rad(-90))

func place_tiles():
	var i = 0
	for pos in tile_positions:
		# todo: tile set
		var template
		if i == 0:
			template = start_template
		elif i == tile_positions.size() - 1: 
			template = end_template
		else:
			template = room_templates.pick_random()
		var instance = template.instantiate() as Room2
		instance.global_position = pos.snappedf(1) 
		print(instance.global_position)
		instance.init(room_size, tile_positions.filter(func (p:Vector2): return is_neighbor(p, pos)))
		add_child(instance)
		i += 1

func is_neighbor(p: Vector2, pos: Vector2):
	return p.snappedf(1).is_equal_approx(Vector2(pos.x - room_size, pos.y).snappedf(1))\
		or p.snappedf(1).is_equal_approx(Vector2(pos.x, pos.y - room_size).snappedf(1))\
		or p.snappedf(1).is_equal_approx(Vector2(pos.x + room_size, pos.y).snappedf(1))\
		or p.snappedf(1).is_equal_approx(Vector2(pos.x, pos.y + room_size).snappedf(1))
