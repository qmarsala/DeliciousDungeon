class_name RoomGenerator2
extends Node2D

@export var room_size: int = 320

@export var start_end_template: PackedScene
@export var room_template: PackedScene
@export var room_templateb: PackedScene

var directions: Array[Vector2] = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
var can_turn_right: bool = true
var tile_positions: Array[Vector2] = []
var start_position: Vector2 = Vector2.ZERO
var end_position: Vector2 = Vector2.ZERO

# todo: increase with dungeon floor
var path_count: int = 3
var tile_count: int = 10
var min_branch: int = 5

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
			if tile_positions.has(current_position.snapped(Vector2.ZERO)): 
				current_position += direction * room_size
				continue
			if (pc > 0 \
				 and (tc >= tile_count * .6 \
				 or tc > min_branch and randf() <= .5 \
				 or current_position.distance_to(end_position) <= room_size \
				 or current_position.distance_to(start_position) <= room_size)):
				break

			tile_positions.append(current_position.snapped(Vector2.ZERO))
			if tc >= tile_count - 1:
				end_position = current_position
				continue

			current_position += direction * room_size
			if randf() < turn_ratio:
				direction = turn(direction)

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
		var template = room_template
		if i == 0 or i == tile_positions.size() - 1: 
			template = start_end_template
		elif randf() < .5:
			template = room_templateb
		var instance = template.instantiate() as Room2
		instance.global_position = pos.snapped(Vector2.ZERO) 
		instance.init(room_size, tile_positions.filter(func (p:Vector2): return is_neighbor(p, pos)))
		add_child(instance)
		i += 1

func is_neighbor(p: Vector2, pos: Vector2):
	return p.x == pos.x - room_size and p.y == pos.y \
		or p.x == pos.x and p.y == pos.y - room_size \
		or p.x == pos.x + room_size and p.y == pos.y \
		or p.x == pos.x and p.y == pos.y + room_size
