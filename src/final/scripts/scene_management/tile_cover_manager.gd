extends Node2D

var north: TileMapLayer
var east: TileMapLayer
var south: TileMapLayer
var west: TileMapLayer

func _ready() -> void:
	for c in get_children():
		if c is not TileMapLayer:
			continue
		if c.name.contains("North"):
			north = c
		elif c.name.contains("East"):
			east = c
		elif c.name.contains("South"):
			south = c
		elif c.name.contains("West"):
			west = c

func init(room_size: int, neighbors: Array[Vector2]):
	enable_area(north, neighbors.has(Vector2(global_position.x, global_position.y - room_size).snappedf(1)))
	enable_area(east, neighbors.has(Vector2(global_position.x + room_size, global_position.y).snappedf(1)))
	enable_area(south, neighbors.has(Vector2(global_position.x, global_position.y + room_size).snappedf(1)))
	enable_area(west, neighbors.has(Vector2(global_position.x - room_size, global_position.y).snappedf(1)))

func enable_area(tile: Node2D,  is_connector: bool) -> void:
	for c in tile.get_children():
		if c.name.contains("Cover") and is_connector:
			c.queue_free()
		else:
			c.enabled = true
