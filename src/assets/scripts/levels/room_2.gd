class_name Room2
extends Node2D


var neighbors: Array[Vector2] = []
var room_size: int = 0

# todo: we could also have a door to spawn another room instead
# of just closing it off
func init(room_size: int, neighbors: Array[Vector2]):
	self.room_size = room_size
	self.neighbors = neighbors
	enable_area($North, self.neighbors.has(Vector2(global_position.x, global_position.y - room_size).snappedf(1)))
	enable_area($East, self.neighbors.has(Vector2(global_position.x + room_size, global_position.y).snappedf(1)))
	enable_area($South, self.neighbors.has(Vector2(global_position.x, global_position.y + room_size).snappedf(1)))
	enable_area($West, self.neighbors.has(Vector2(global_position.x - room_size, global_position.y).snappedf(1)))

func enable_area(tile: Node2D,  is_connector: bool) -> void:
	for c in tile.get_children():
		if c.name.contains("Cover"):
			c.enabled = not is_connector
		else:
			c.enabled = is_connector
