class_name Room2
extends Node2D


var neighbors: Array[Vector2] = []
var room_size: int = 0

func init(room_size: int, neighbors: Array[Vector2]):
	self.room_size = room_size
	self.neighbors = neighbors
	if not self.neighbors.has(Vector2(global_position.x, global_position.y - room_size)):
		$NorthCoverBG.enabled = true
		$NorthCover.enabled = true
	if not self.neighbors.has(Vector2(global_position.x + room_size, global_position.y)):
		$EastCoverBG.enabled = true
		$EastCover.enabled = true
	if not self.neighbors.has(Vector2(global_position.x, global_position.y + room_size)):
		$SouthCoverBG.enabled = true
		$SouthCover.enabled = true
	if not self.neighbors.has(Vector2(global_position.x - room_size, global_position.y)):
		$WestCoverBG.enabled = true
		$WestCover.enabled = true
