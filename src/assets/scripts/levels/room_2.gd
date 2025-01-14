class_name Room2
extends Node2D


var neighbors: Array[Vector2] = []
var room_size: int = 0

# todo: we could also have a door to spawn another room instead
# of just closing it off
func init(room_size: int, neighbors: Array[Vector2]):
	self.room_size = room_size
	self.neighbors = neighbors
	if not self.neighbors.has(Vector2(global_position.x, global_position.y - room_size).snappedf(1)):
		$NorthCoverBG.enabled = true
		$NorthCover.enabled = true
	if not self.neighbors.has(Vector2(global_position.x + room_size, global_position.y).snappedf(1)):
		$EastCoverBG.enabled = true
		$EastCover.enabled = true
	if not self.neighbors.has(Vector2(global_position.x, global_position.y + room_size).snappedf(1)):
		$SouthCoverBG.enabled = true
		$SouthCover.enabled = true
	if not self.neighbors.has(Vector2(global_position.x - room_size, global_position.y).snappedf(1)):
		$WestCoverBG.enabled = true
		$WestCover.enabled = true
