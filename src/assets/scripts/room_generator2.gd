class_name RoomGenerator2
extends Node2D

@export var room_size: float = 160

@export var room_template: PackedScene

var directions: Array[Vector2] = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
var can_turn_right: bool = true
var end_position: Vector2
var tile_positions: Array[Vector2] = []
var path_count: int = 7
var tile_count: int = 20
var min_branch: int = 5

func _ready() -> void:
	var start_position = Vector2.ZERO
	for j in path_count:
		var direction = directions.pick_random()
		var turn_ratio = randf_range(0.15, .85)
		var current_position = start_position
		if j > 0:
			current_position = tile_positions[randi_range(tile_count * .3, tile_count * .7)] + direction * room_size
		for i in tile_count:
			if (j > 0 and (i >= tile_count * .6 or i > min_branch and randf() <= .5 or current_position.distance_to(end_position) < room_size or current_position.distance_to(start_position) < room_size)):
				print(str(current_position) + " | " + str(start_position), " | ", current_position)
				break

			var instance = room_template.instantiate() as Node2D
			instance.global_position = current_position 
			instance.init(i, i == 0 and j == 0, j == 0 and i == tile_count - 1)
			tile_positions.append(current_position)
			add_child(instance)
			if i >= tile_count - 1:
				end_position = current_position
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
