extends Node2D

var room_size: int = 0
var neighbors: Array[Vector2]

func init(room_size: int, neighbors: Array[Vector2]) -> void:
	self.room_size = room_size
	self.neighbors = neighbors

func _ready() -> void:
	for c in get_children():
		if c is not TileMapLayer:
			continue
		if c.name.contains("North"):
			enable_area(c, neighbors.has(Vector2(global_position.x, global_position.y - room_size).snappedf(1)))
		elif c.name.contains("East"):
			enable_area(c, neighbors.has(Vector2(global_position.x + room_size, global_position.y).snappedf(1)))
		elif c.name.contains("South"):
			enable_area(c, neighbors.has(Vector2(global_position.x, global_position.y + room_size).snappedf(1)))
		elif c.name.contains("West"):
			enable_area(c, neighbors.has(Vector2(global_position.x - room_size, global_position.y).snappedf(1)))

func enable_area(tile: Node2D,  is_connector: bool) -> void:
	if is_connector:
		tile.queue_free()
	else:
		tile.enabled = true
